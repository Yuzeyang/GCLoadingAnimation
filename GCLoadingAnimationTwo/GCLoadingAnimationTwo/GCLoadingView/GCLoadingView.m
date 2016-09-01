//
//  GCLoadingView.m
//  GCLoadingAnimationTwo
//
//  Created by 宫城 on 16/8/29.
//  Copyright © 2016年 宫城. All rights reserved.
//

#import "GCLoadingView.h"
#import "GCLoadingCircle.h"

#define kGCLoadingViewMaxHeight 250

#define kGCPullMaxDistance  60

typedef NS_ENUM(NSInteger, GCLoadingState) {
    GCLoadingStateNormal,
    GCLoadingStateLoading,
    GCLoadingStateCancelled
};

typedef void(^GCLoadingBlock)();

@interface GCLoadingView ()

@property (nonatomic, strong) UIScrollView *associatedScrollView;
@property (nonatomic, strong) CAShapeLayer *loadLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) GCLoadingState loadingState;
@property (nonatomic, strong) UIView *centerHelperView;
@property (nonatomic, assign) CGFloat progress;
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

static NSInteger kGCLoadingViewMinHeight = 64;

@implementation GCLoadingView

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        self.associatedScrollView = scrollView;
        self.loadingState = GCLoadingStateNormal;
        
        [self drawOriginPath];
        [self addObersers];
        
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
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        _displayLink.paused = YES;
    }
    return _displayLink;
}

- (GCLoadingCircle *)loadingCircle {
    if (!_loadingCircle) {
        _loadingCircle = [[GCLoadingCircle alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.associatedScrollView.frame)/2,
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
    self.loadingState = GCLoadingStateNormal;
    kGCLoadingViewMinHeight = 64;
    [self.loadingCircle stopLoading];
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.centerHelperView setFrame:CGRectMake(CGRectGetWidth(self.associatedScrollView.frame)/2, kGCLoadingViewMinHeight, 2, 2)];
    } completion:nil];
}

- (void)drawOriginPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, kGCLoadingViewMinHeight)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.associatedScrollView.frame), kGCLoadingViewMinHeight)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.associatedScrollView.frame), 0)];
    
    self.loadLayer.path = path.CGPath;
}

- (void)addObersers {
    [self.associatedScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.associatedScrollView addObserver:self forKeyPath:@"panGestureRecognizer.state" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    if (self.loadingState == GCLoadingStateLoading) {
        return;
    }
    
    if (self.displayLink.paused) {
        self.displayLink.paused = NO;
    }

    if (self.loadingState == GCLoadingStateNormal) {
        UIPanGestureRecognizer *panGesture = self.associatedScrollView.panGestureRecognizer;
        CGFloat translationY = [panGesture translationInView:self.associatedScrollView].y;
        CGFloat locationX = [panGesture locationInView:self.associatedScrollView].x;
        CGFloat locationY = MIN(MAX(translationY + kGCLoadingViewMinHeight, kGCLoadingViewMinHeight), kGCLoadingViewMaxHeight);
        [self.centerHelperView setFrame:CGRectMake(locationX, locationY, 2, 2)];
    }

    [self.loadingCircle setProgess:progress];
}

- (void)drawLoadLayerWithCenter:(CGPoint)center {
    CGFloat x = center.x;
    CGFloat y = center.y;
    CGFloat locationY = (y - kGCLoadingViewMinHeight)/2 + kGCLoadingViewMinHeight;

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
    CGPoint r1 = CGPointMake(CGRectGetWidth(self.associatedScrollView.frame)/3 + 2*x/3, locationY + (y - kGCLoadingViewMinHeight)/4);
    CGPoint r2 = CGPointMake(CGRectGetWidth(self.associatedScrollView.frame)*2/3 + x/3, locationY);
    CGPoint r3 = CGPointMake(CGRectGetWidth(self.associatedScrollView.frame), locationY);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:l3];
    [path addCurveToPoint:l1 controlPoint1:l3 controlPoint2:l2];
    [path addCurveToPoint:r1 controlPoint1:l1 controlPoint2:c];
    [path addCurveToPoint:r3 controlPoint1:r1 controlPoint2:r2];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.associatedScrollView.frame), 0)];
    
    self.loadLayer.path = path.CGPath;
}

- (void)displayLinkAction:(CADisplayLink *)displayLink {
    CALayer *centerHelperViewLayer = (CALayer *)[self.centerHelperView.layer presentationLayer];
    CGRect centerHelperViewRect = [[centerHelperViewLayer valueForKey:@"frame"] CGRectValue];
    [self drawLoadLayerWithCenter:centerHelperViewRect.origin];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint contentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        if (contentOffset.y < 0) {
            self.progress = MAX(0.0, MIN(fabs(contentOffset.y/kGCPullMaxDistance), 1.0));
        } else {
            self.progress = 0;
        }
    }
    
    if ([keyPath isEqualToString:@"panGestureRecognizer.state"]) {
        NSInteger state = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
        if (state == UIGestureRecognizerStateEnded ||
            state == UIGestureRecognizerStateCancelled ||
            state == UIGestureRecognizerStateFailed) {
            if (self.loadingState != GCLoadingStateNormal) {
                return;
            }
            
            if (self.progress < 1.0) {
                if (self.progress == 0) {
                    self.loadingState = GCLoadingStateNormal;
                } else {
                    self.loadingState = GCLoadingStateCancelled;
                    self.associatedScrollView.scrollEnabled = NO;
                }
            } else {
                self.loadingState = GCLoadingStateLoading;
                kGCLoadingViewMinHeight+=30;
                [self.loadingCircle startLoading];
                self.associatedScrollView.scrollEnabled = NO;
                if (self.loadingBlock) {
                    self.loadingBlock();
                }
            }
            
            if (self.loadingState != GCLoadingStateNormal) {
                [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.centerHelperView setFrame:CGRectMake(CGRectGetWidth(self.associatedScrollView.frame)/2, kGCLoadingViewMinHeight, 2, 2)];
                } completion:^(BOOL finished) {
                    self.associatedScrollView.scrollEnabled = YES;
                    if (self.loadingState == GCLoadingStateCancelled) {
                        self.loadingState = GCLoadingStateNormal;
                    }
                }];
            }

        }
    }
}

@end
