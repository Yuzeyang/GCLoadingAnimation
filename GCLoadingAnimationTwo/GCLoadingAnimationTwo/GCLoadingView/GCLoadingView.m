//
//  GCLoadingView.m
//  GCLoadingAnimationTwo
//
//  Created by 宫城 on 16/8/29.
//  Copyright © 2016年 宫城. All rights reserved.
//

#import "GCLoadingView.h"

#define kGCLoadingViewMinHeight 44
#define kGCLoadingViewMaxHeight 250

@interface GCLoadingView ()

@property (nonatomic, strong) UIView *associatedView;
@property (nonatomic, strong) CAShapeLayer *loadLayer;

@property (nonatomic, strong) UIView *l3;
@property (nonatomic, strong) UIView *l2;
@property (nonatomic, strong) UIView *l1;
@property (nonatomic, strong) UIView *c;
@property (nonatomic, strong) UIView *r3;
@property (nonatomic, strong) UIView *r2;
@property (nonatomic, strong) UIView *r1;

@end

@implementation GCLoadingView

- (instancetype)initWithScrollView:(UIView *)scrollView hasNavigationBar:(BOOL)hasNavigationBar {
    self = [super init];
    if (self) {
        self.associatedView = scrollView;
        [self drawOriginPath];
        [self addPanGestureInAssociatedView];
        
        self.l3 = [UIView new];
        self.l2 = [UIView new];
        self.l1 = [UIView new];
        self.c = [UIView new];
        self.r3 = [UIView new];
        self.r2 = [UIView new];
        self.r1 = [UIView new];
        self.l3.backgroundColor = [UIColor blackColor];
        self.l2.backgroundColor = [UIColor blackColor];
        self.l1.backgroundColor = [UIColor blackColor];
        self.c.backgroundColor = [UIColor blackColor];
        self.r3.backgroundColor = [UIColor blackColor];
        self.r2.backgroundColor = [UIColor blackColor];
        self.r1.backgroundColor = [UIColor blackColor];
        [self addSubview:self.l3];
        [self addSubview:self.l2];
        [self addSubview:self.l1];
        [self addSubview:self.c];
        [self addSubview:self.r3];
        [self addSubview:self.r2];
        [self addSubview:self.r1];
    }
    return self;
}

- (void)drawOriginPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, kGCLoadingViewMinHeight)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.associatedView.frame), kGCLoadingViewMinHeight)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.associatedView.frame), 0)];
    
    self.loadLayer = [CAShapeLayer layer];
    self.loadLayer.path = path.CGPath;
    self.loadLayer.fillColor = [UIColor colorWithRed:255/255.0 green:80/255.0 blue:80/255.0 alpha:1].CGColor;
    self.loadLayer.actions = @{@"position": [NSNull null],
                               @"bounds": [NSNull null],
                               @"path": [NSNull null]};
    [self.layer addSublayer:self.loadLayer];
}

- (void)addPanGestureInAssociatedView {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(updateLoadLayer:)];
    [self.associatedView addGestureRecognizer:panGesture];
}

- (void)updateLoadLayer:(UIPanGestureRecognizer *)panGesture {
    if (panGesture.state == UIGestureRecognizerStateEnded ||
        panGesture.state == UIGestureRecognizerStateCancelled) {
    
    } else {
        CGFloat translationY = [panGesture translationInView:self.associatedView].y;
        CGFloat locationX = [panGesture locationInView:self.associatedView].x;
        CGFloat locationY = MIN(MAX(translationY + kGCLoadingViewMinHeight, kGCLoadingViewMinHeight), kGCLoadingViewMaxHeight);
        [self drawLoadLayerWithCenter:CGPointMake(locationX, locationY)];
    }
}

- (void)drawLoadLayerWithCenter:(CGPoint)center {
    CGFloat x = center.x;
    CGFloat y = center.y;
    
    CGFloat locationY = (y - kGCLoadingViewMinHeight)/2 + kGCLoadingViewMinHeight;
    
    [self.l3 setFrame:CGRectMake(0, locationY, 2, 2)];
    [self.l2 setFrame:CGRectMake(x/3, locationY, 2, 2)];
    [self.l1 setFrame:CGRectMake(2*x/3, locationY + (y - kGCLoadingViewMinHeight)/4, 2, 2)];
    [self.c setFrame:CGRectMake(x, y, 2, 2)];
    [self.r3 setFrame:CGRectMake(CGRectGetWidth(self.associatedView.frame), locationY, 2, 2)];
    [self.r2 setFrame:CGRectMake(CGRectGetWidth(self.associatedView.frame)*2/3 + x/3, locationY, 2, 2)];
    [self.r1 setFrame:CGRectMake(CGRectGetWidth(self.associatedView.frame)/3 + 2*x/3, locationY + (y - kGCLoadingViewMinHeight)/4, 2, 2)];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, locationY)];
    [path addCurveToPoint:CGPointMake(2*x/3, locationY + (y - kGCLoadingViewMinHeight)/4) controlPoint1:CGPointMake(0, locationY) controlPoint2:CGPointMake(x/3, locationY)];
//    [path addCurveToPoint:CGPointMake(CGRectGetWidth(self.associatedView.frame)/3 + 2*x/3, locationY + (y - kGCLoadingViewMinHeight)/4)
//            controlPoint1:CGPointMake(x, y)
//            controlPoint2:CGPointMake(CGRectGetWidth(self.associatedView.frame)/3 + 2*x/3, locationY + (y - kGCLoadingViewMinHeight)/4)];
    [path addCurveToPoint:CGPointMake(CGRectGetWidth(self.associatedView.frame)/3 + 2*x/3, locationY + (y - kGCLoadingViewMinHeight)/4)
            controlPoint1:CGPointMake(2*x/3, locationY + (y - kGCLoadingViewMinHeight)/4)
            controlPoint2:CGPointMake(x, y)];
//    [path addCurveToPoint:CGPointMake(CGRectGetWidth(self.associatedView.frame)/3 + 2*x/3, 4*y/4)
//            controlPoint1:CGPointMake(2*x/3, 4*y/4)
//            controlPoint2:CGPointMake(x, y)];
    [path addCurveToPoint:CGPointMake(CGRectGetWidth(self.associatedView.frame), locationY)
            controlPoint1:CGPointMake(CGRectGetWidth(self.associatedView.frame)/3 + 2*x/3, locationY + (y - kGCLoadingViewMinHeight)/4)
            controlPoint2:CGPointMake(CGRectGetWidth(self.associatedView.frame)*2/3 + x/3, locationY)];
//    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.associatedView.frame), y)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.associatedView.frame), 0)];
    
    self.loadLayer.path = path.CGPath;
}

@end
