//
//  GCLoadingView.m
//  GCLoadingAnimationTwo
//
//  Created by 宫城 on 16/8/29.
//  Copyright © 2016年 宫城. All rights reserved.
//

#import "GCLoadingView.h"
#import "GCLoadingCircle.h"

//#define kGCLoadingViewMinHeight 64
#define kGCLoadingViewMaxHeight 250

#define kGCPullMaxDistance  100

typedef void(^GCLoadingBlock)();

@interface GCLoadingView ()

@property (nonatomic, strong) UIView *associatedView;
@property (nonatomic, strong) CAShapeLayer *loadLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) UIView *centerHelperView;
@property (nonatomic, strong) GCLoadingCircle *loadingCircle;
@property (nonatomic, copy) GCLoadingBlock loadingBlock;

// 辅助视图
//@property (nonatomic, strong) UIView *l3;
//@property (nonatomic, strong) UIView *l2;
//@property (nonatomic, strong) UIView *l1;
//@property (nonatomic, strong) UIView *c;
//@property (nonatomic, strong) UIView *r3;
//@property (nonatomic, strong) UIView *r2;
//@property (nonatomic, strong) UIView *r1;

@end

static NSInteger kGCLoadingViewMinHeight =64;

@implementation GCLoadingView

- (instancetype)initWithScrollView:(UIView *)scrollView hasNavigationBar:(BOOL)hasNavigationBar {
    self = [super init];
    if (self) {
        self.associatedView = scrollView;
        self.isAnimating = NO;
        
        [self drawOriginPath];
        [self addPanGestureInAssociatedView];
        
//        self.l3 = [UIView new];
//        self.l2 = [UIView new];
//        self.l1 = [UIView new];
//        self.c = [UIView new];
//        self.r3 = [UIView new];
//        self.r2 = [UIView new];
//        self.r1 = [UIView new];
//        self.l3.backgroundColor = [UIColor blackColor];
//        self.l2.backgroundColor = [UIColor blackColor];
//        self.l1.backgroundColor = [UIColor blackColor];
//        self.c.backgroundColor = [UIColor blackColor];
//        self.r3.backgroundColor = [UIColor blackColor];
//        self.r2.backgroundColor = [UIColor blackColor];
//        self.r1.backgroundColor = [UIColor blackColor];
//        [self addSubview:self.l3];
//        [self addSubview:self.l2];
//        [self addSubview:self.l1];
//        [self addSubview:self.c];
//        [self addSubview:self.r3];
//        [self addSubview:self.r2];
//        [self addSubview:self.r1];
    }
    return self;
}

- (UIView *)centerHelperView {
    if (!_centerHelperView) {
        _centerHelperView = [UIView new];
        [self addSubview:_centerHelperView];
    }
    return _centerHelperView;
}

- (CAShapeLayer *)loadLayer {
    if (!_loadLayer) {
        _loadLayer = [CAShapeLayer layer];
        _loadLayer.fillColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:80/255.0 alpha:1].CGColor;
        _loadLayer.actions = @{@"position": [NSNull null],
                                   @"bounds": [NSNull null],
                                   @"path": [NSNull null]};
        [self.layer addSublayer:_loadLayer];
    }
    return _loadLayer;
}

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _displayLink.paused = YES;
    }
    return _displayLink;
}

- (GCLoadingCircle *)loadingCircle {
    if (!_loadingCircle) {
        _loadingCircle = [[GCLoadingCircle alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.associatedView.frame)/2,
                                                                           40 + kGCLoadingCircleRadius, 1, 1)];
        _loadingCircle.backgroundColor = [UIColor clearColor];
        [self addSubview:_loadingCircle];
    }
    return _loadingCircle;
}

- (void)addLoadingBlock:(void (^)())block {
    self.loadingBlock = block;
}

- (void)stopLoading {
    [self.loadingCircle stopLoading];
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        kGCLoadingViewMinHeight -= 30;
        [self.centerHelperView setFrame:CGRectMake(CGRectGetWidth(self.associatedView.frame)/2, kGCLoadingViewMinHeight, 2, 2)];
        self.isAnimating = NO;
    } completion:nil];
}

- (void)drawOriginPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, kGCLoadingViewMinHeight)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.associatedView.frame), kGCLoadingViewMinHeight)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.associatedView.frame), 0)];
    
    self.loadLayer.path = path.CGPath;
}

- (void)addPanGestureInAssociatedView {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(updateLoadLayer:)];
    [self.associatedView addGestureRecognizer:panGesture];
}

- (void)updateLoadLayer:(UIPanGestureRecognizer *)panGesture {
    if (self.isAnimating) {
        return;
    }
    
    if (panGesture.state == UIGestureRecognizerStateEnded ||
        panGesture.state == UIGestureRecognizerStateCancelled ||
        panGesture.state == UIGestureRecognizerStateFailed) {
        if ([panGesture translationInView:self.associatedView].y < kGCPullMaxDistance) {
            self.isAnimating = NO;
            [UIView animateWithDuration:1.0 animations:^{
                [self.loadingCircle setProgess:0];
            }];
        } else {
            self.isAnimating = YES;
            [self.loadingCircle startLoading];
            if (self.loadingBlock) {
                self.loadingBlock();
            }
            
            [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
        }
        
        [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            CGFloat centerY = self.isAnimating ? kGCLoadingViewMinHeight + 30 : kGCLoadingViewMinHeight;
            kGCLoadingViewMinHeight = self.isAnimating ? kGCLoadingViewMinHeight + 30 : kGCLoadingViewMinHeight;
            [self.centerHelperView setFrame:CGRectMake(CGRectGetWidth(self.associatedView.frame)/2, kGCLoadingViewMinHeight, 2, 2)];
        } completion:nil];
        
        // ==============
//        if ([panGesture translationInView:self.associatedView].y < kGCPullMaxDistance) {
//            [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                [self.centerHelperView setFrame:CGRectMake(CGRectGetWidth(self.associatedView.frame)/2, kGCLoadingViewMinHeight, 2, 2)];
//            } completion:nil];
//            [UIView animateWithDuration:1.0 animations:^{
//                [self.loadingCircle setProgess:0];
//            }];
//        } else {
//            [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                [self.centerHelperView setFrame:CGRectMake(CGRectGetWidth(self.associatedView.frame)/2, kGCLoadingViewMinHeight + 30, 2, 2)];
//            } completion:nil];
//            [self.loadingCircle startLoading];
//        }
    } else {
        if (self.displayLink.paused) {
            self.displayLink.paused = NO;
        }
        
        CGFloat translationY = [panGesture translationInView:self.associatedView].y;
        CGFloat locationX = [panGesture locationInView:self.associatedView].x;
        CGFloat locationY = MIN(MAX(translationY + kGCLoadingViewMinHeight, kGCLoadingViewMinHeight), kGCLoadingViewMaxHeight);
        [self.centerHelperView setFrame:CGRectMake(locationX, locationY, 2, 2)];
        CGFloat progress = MAX(MIN(kGCPullMaxDistance, translationY)/kGCPullMaxDistance, 0);
        [self.loadingCircle setProgess:progress];
    }
}

- (void)drawLoadLayerWithCenter:(CGPoint)center {
    CGFloat x = center.x;
    CGFloat y = center.y;
    CGFloat locationY = (y - kGCLoadingViewMinHeight)/2 + kGCLoadingViewMinHeight;
//    if (self.isAnimating) {
//        locationY += 30;
//    }

//    [self.l3 setFrame:CGRectMake(0, locationY, 2, 2)];
//    [self.l2 setFrame:CGRectMake(x/3, locationY, 2, 2)];
//    [self.l1 setFrame:CGRectMake(2*x/3, locationY + (y - kGCLoadingViewMinHeight)/4, 2, 2)];
////    [self.c setFrame:CGRectMake(x, y, 2, 2)];
//    [self.r3 setFrame:CGRectMake(CGRectGetWidth(self.associatedView.frame), locationY, 2, 2)];
//    [self.r2 setFrame:CGRectMake(CGRectGetWidth(self.associatedView.frame)*2/3 + x/3, locationY, 2, 2)];
//    [self.r1 setFrame:CGRectMake(CGRectGetWidth(self.associatedView.frame)/3 + 2*x/3, locationY + (y - kGCLoadingViewMinHeight)/4, 2, 2)];
    
    CGPoint l3 = CGPointMake(0, locationY);
    CGPoint l2 = CGPointMake(x/3, locationY);
    CGPoint l1 = CGPointMake(2*x/3, locationY + (y - kGCLoadingViewMinHeight)/4);
    CGPoint c = CGPointMake(x, y);
    CGPoint r1 = CGPointMake(CGRectGetWidth(self.associatedView.frame)/3 + 2*x/3, locationY + (y - kGCLoadingViewMinHeight)/4);
    CGPoint r2 = CGPointMake(CGRectGetWidth(self.associatedView.frame)*2/3 + x/3, locationY);
    CGPoint r3 = CGPointMake(CGRectGetWidth(self.associatedView.frame), locationY);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:l3];
    [path addCurveToPoint:l1 controlPoint1:l3 controlPoint2:l2];
    [path addCurveToPoint:r1 controlPoint1:l1 controlPoint2:c];
    [path addCurveToPoint:r3 controlPoint1:r1 controlPoint2:r2];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.associatedView.frame), 0)];
    
    self.loadLayer.path = path.CGPath;
}

- (void)displayLinkAction:(CADisplayLink *)displayLink {
    CALayer *centerHelperViewLayer = (CALayer *)[self.centerHelperView.layer presentationLayer];
    CGRect centerHelperViewRect = [[centerHelperViewLayer valueForKey:@"frame"] CGRectValue];
    [self drawLoadLayerWithCenter:centerHelperViewRect.origin];
}

@end
