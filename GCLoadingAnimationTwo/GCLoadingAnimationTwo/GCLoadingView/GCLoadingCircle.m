//
//  GCLoadingCircle.m
//  GCLoadingAnimationTwo
//
//  Created by 宫城 on 16/8/31.
//  Copyright © 2016年 宫城. All rights reserved.
//

#import "GCLoadingCircle.h"



@interface GCLoadingCircle ()

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, assign) CGFloat progess;

@end

@implementation GCLoadingCircle

- (void)drawRect:(CGRect)rect {
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    [circlePath moveToPoint:CGPointMake(0, - kGCLoadingCircleRadius)];
    [circlePath addArcWithCenter:CGPointMake(0, 0) radius:kGCLoadingCircleRadius startAngle:-M_PI/2 endAngle:((M_PI*17/9)*self.progess - M_PI/2) clockwise:YES];
    
    self.circleLayer.path = circlePath.CGPath;
}

- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.strokeColor = [UIColor darkGrayColor].CGColor;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_circleLayer];
    }
    return _circleLayer;
}

- (void)setProgess:(CGFloat)progess {
    _progess = progess;
    [self setNeedsDisplay];
}

- (void)startLoading {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI*2);
    rotationAnimation.beginTime = CACurrentMediaTime();
    rotationAnimation.duration = 1.0;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.circleLayer addAnimation:rotationAnimation forKey:nil];
}

- (void)stopLoading {
    [self.circleLayer removeAllAnimations];
    [self.circleLayer removeFromSuperlayer];
    self.circleLayer = nil;
}

@end
