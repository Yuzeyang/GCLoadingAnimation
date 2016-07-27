//
//  GCLoadingLayer.m
//  GCLoadingAnimationOne
//
//  Created by 宫城 on 16/7/25.
//  Copyright © 2016年 宫城. All rights reserved.
//

#import "GCLoadingLayer.h"
#import <UIKit/UIKit.h>

#define GCCircleRadius 50

#define GCDeviceWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define GCDeviceHeight CGRectGetHeight([UIScreen mainScreen].bounds)

#define GCLoadingLayerCenterX 0
#define GCLoadingLayerCenterY 0

@interface GCLoadingLayer ()

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *triangleLayer;
@property (nonatomic, strong) CAShapeLayer *rectLayer;
@property (nonatomic, strong) CAShapeLayer *waterLayer;

@end

@implementation GCLoadingLayer

#pragma mark - circle animation
- (void)startAnimation {
    UIBezierPath *startPath = [self circleStartPath];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(GCLoadingLayerCenterX - GCCircleRadius, GCLoadingLayerCenterY - GCCircleRadius, GCCircleRadius*2, GCCircleRadius*2)];
    
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.path = endPath.CGPath;
    self.circleLayer.fillColor = [UIColor orangeColor].CGColor;
    [self addSublayer:self.circleLayer];
    
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    circleAnimation.fromValue = (__bridge id _Nullable)(startPath.CGPath);
    circleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    circleAnimation.duration = 0.2f;
    circleAnimation.fillMode = kCAFillModeForwards;
    circleAnimation.delegate = self;
    circleAnimation.removedOnCompletion = NO;
    [circleAnimation setValue:@"circleAnimation" forKey:@"animationName"];
    [self.circleLayer addAnimation:circleAnimation forKey:nil];
}

- (UIBezierPath *)circleStartPath {
    return [UIBezierPath bezierPathWithOvalInRect:CGRectMake(GCLoadingLayerCenterX, GCLoadingLayerCenterY, 0, 0)];
}

- (void)circleScaleAnimation {
    UIBezierPath *scaleXPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(GCLoadingLayerCenterX - GCCircleRadius*1.1, GCLoadingLayerCenterY - GCCircleRadius, GCCircleRadius*2.2, GCCircleRadius*2)];
    UIBezierPath *scaleYPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(GCLoadingLayerCenterX - GCCircleRadius, GCLoadingLayerCenterY - GCCircleRadius*1.1, GCCircleRadius*2, GCCircleRadius*2.2)];
    
    CABasicAnimation *circleScaleXOneAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    circleScaleXOneAnimation.fromValue = (__bridge id _Nullable)(self.circleLayer.path);
    circleScaleXOneAnimation.toValue = (__bridge id _Nullable)(scaleXPath.CGPath);
    circleScaleXOneAnimation.duration = 0.2f;
    circleScaleXOneAnimation.beginTime = 0.0;
    
    CABasicAnimation *circleScaleXTwoAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    circleScaleXTwoAnimation.fromValue = (__bridge id _Nullable)(scaleXPath.CGPath);
    circleScaleXTwoAnimation.toValue = (__bridge id _Nullable)(self.circleLayer.path);
    circleScaleXTwoAnimation.duration = 0.2f;
    circleScaleXTwoAnimation.beginTime = circleScaleXOneAnimation.beginTime + circleScaleXOneAnimation.duration;
    
    CABasicAnimation *circleScaleYOneAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    circleScaleYOneAnimation.fromValue = (__bridge id _Nullable)(self.circleLayer.path);
    circleScaleYOneAnimation.toValue = (__bridge id _Nullable)(scaleYPath.CGPath);
    circleScaleYOneAnimation.duration = 0.2f;
    circleScaleYOneAnimation.beginTime = circleScaleXTwoAnimation.beginTime + circleScaleXTwoAnimation.duration;
    
    CABasicAnimation *circleScaleYTwoAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    circleScaleYTwoAnimation.fromValue = (__bridge id _Nullable)(scaleYPath.CGPath);
    circleScaleYTwoAnimation.toValue = (__bridge id _Nullable)(self.circleLayer.path);
    circleScaleYTwoAnimation.duration = 0.2f;
    circleScaleYTwoAnimation.beginTime = circleScaleYOneAnimation.beginTime + circleScaleYOneAnimation.duration;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[circleScaleXOneAnimation,circleScaleXTwoAnimation,circleScaleYOneAnimation,circleScaleYTwoAnimation];
    animationGroup.duration = circleScaleYTwoAnimation.beginTime + circleScaleYTwoAnimation.duration;
    animationGroup.delegate = self;
    [animationGroup setValue:@"circleScaleAnimation" forKey:@"animationName"];
    [self.circleLayer addAnimation:animationGroup forKey:nil];
}

- (void)dismissCircle {
    CABasicAnimation *dismissAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    dismissAnimation.toValue = (__bridge id _Nullable)([self circleStartPath].CGPath);
    dismissAnimation.duration = 0.6;
    dismissAnimation.fillMode = kCAFillModeForwards;
    dismissAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    dismissAnimation.beginTime = 0.0;
    dismissAnimation.removedOnCompletion = NO;
    dismissAnimation.delegate = self;
    [dismissAnimation setValue:@"dismissAnimation" forKey:@"animationName"];
    [self.circleLayer addAnimation:dismissAnimation forKey:nil];
}

#pragma mark - triangle aniamtion
- (void)showTriangle {
    UIBezierPath *originTrianglePath = [UIBezierPath bezierPath];
    [originTrianglePath moveToPoint:[self triangleLeftPointWithScale:1.0]];
    [originTrianglePath addLineToPoint:[self triangleRightPointWithScale:1.0]];
    [originTrianglePath addLineToPoint:[self triangleTopPointWithScale:1.0]];
    [originTrianglePath closePath];
    
    self.triangleLayer = [CAShapeLayer layer];
    self.triangleLayer.path = originTrianglePath.CGPath;
    self.triangleLayer.fillColor = [UIColor orangeColor].CGColor;
    [self addSublayer:self.triangleLayer];
    
    UIBezierPath *blowUpLeftTrianglePath = [UIBezierPath bezierPath];
    [blowUpLeftTrianglePath moveToPoint:[self triangleLeftPointWithScale:1.2]];
    [blowUpLeftTrianglePath addLineToPoint:[self triangleRightPointWithScale:1.0]];
    [blowUpLeftTrianglePath addLineToPoint:[self triangleTopPointWithScale:1.0]];
    [blowUpLeftTrianglePath closePath];
    
    UIBezierPath *blowUpRightTrianglePath = [UIBezierPath bezierPath];
    [blowUpRightTrianglePath moveToPoint:[self triangleLeftPointWithScale:1.2]];
    [blowUpRightTrianglePath addLineToPoint:[self triangleRightPointWithScale:1.2]];
    [blowUpRightTrianglePath addLineToPoint:[self triangleTopPointWithScale:1.0]];
    [blowUpRightTrianglePath closePath];
    
    UIBezierPath *blowUpTopTrianglePath = [UIBezierPath bezierPath];
    [blowUpTopTrianglePath moveToPoint:[self triangleLeftPointWithScale:1.2]];
    [blowUpTopTrianglePath addLineToPoint:[self triangleRightPointWithScale:1.2]];
    [blowUpTopTrianglePath addLineToPoint:[self triangleTopPointWithScale:1.2]];
    [blowUpTopTrianglePath closePath];
    
    CABasicAnimation *blowUpLeftAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    blowUpLeftAnimation.fromValue = (__bridge id _Nullable)(self.triangleLayer.path);
    blowUpLeftAnimation.toValue = (__bridge id _Nullable)(blowUpLeftTrianglePath.CGPath);
    blowUpLeftAnimation.duration = 0.2f;
    blowUpLeftAnimation.beginTime = 0.0;
    
    CABasicAnimation *blowUpRightAniamtion = [CABasicAnimation animationWithKeyPath:@"path"];
    blowUpRightAniamtion.fromValue = (__bridge id _Nullable)(blowUpLeftTrianglePath.CGPath);
    blowUpRightAniamtion.toValue = (__bridge id _Nullable)blowUpRightTrianglePath.CGPath;
    blowUpRightAniamtion.duration = 0.2f;
    blowUpRightAniamtion.beginTime = blowUpLeftAnimation.beginTime + blowUpLeftAnimation.duration;
    
    CABasicAnimation *blowUpTopAniamtion = [CABasicAnimation animationWithKeyPath:@"path"];
    blowUpTopAniamtion.fromValue = (__bridge id _Nullable)blowUpRightTrianglePath.CGPath;
    blowUpTopAniamtion.toValue = (__bridge id _Nullable)blowUpTopTrianglePath.CGPath;
    blowUpTopAniamtion.duration = 0.2f;
    blowUpTopAniamtion.beginTime = blowUpRightAniamtion.beginTime + blowUpRightAniamtion.duration;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[blowUpLeftAnimation,blowUpRightAniamtion,blowUpTopAniamtion];
    group.duration = blowUpTopAniamtion.beginTime + blowUpTopAniamtion.duration;
    group.removedOnCompletion = NO;
    group.delegate = self;
    group.fillMode = kCAFillModeForwards;
    [group setValue:@"triangleAniamtion" forKey:@"animationName"];
    [self.triangleLayer addAnimation:group forKey:nil];
}

- (CGPoint)triangleLeftPointWithScale:(CGFloat)scale {
    CGFloat x = GCLoadingLayerCenterX - powf(3, 0.5)*GCCircleRadius*scale/2;
    CGFloat y = GCLoadingLayerCenterY + GCCircleRadius*scale/2;
    return CGPointMake(x, y);
}

- (CGPoint)triangleRightPointWithScale:(CGFloat)scale {
    CGFloat x = GCLoadingLayerCenterX + powf(3, 0.5)*GCCircleRadius*scale/2;
    CGFloat y = GCLoadingLayerCenterY + GCCircleRadius*scale/2;
    return CGPointMake(x, y);
}

- (CGPoint)triangleTopPointWithScale:(CGFloat)scale {
    CGFloat x = GCLoadingLayerCenterX;
    CGFloat y = GCLoadingLayerCenterY - GCCircleRadius*scale;
    return CGPointMake(x, y);
}

- (void)rotateTriangle {
    CABasicAnimation *rotationAniamtion = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAniamtion.toValue = @(M_PI*2);
    rotationAniamtion.duration = 0.4;
    rotationAniamtion.fillMode = kCAFillModeForwards;
    rotationAniamtion.delegate = self;
    rotationAniamtion.beginTime = CACurrentMediaTime();
    [rotationAniamtion setValue:@"rotationAniamtion" forKey:@"animationName"];
    [self.triangleLayer addAnimation:rotationAniamtion forKey:nil];
}

#pragma mark - rect aniamtion
- (void)drawBackgroundRectLine {
    [self drawRectWithLineColor:[UIColor orangeColor].CGColor animationValue:nil];
}

- (void)drawRectLine {
    [self drawRectWithLineColor:[UIColor darkGrayColor].CGColor animationValue:@"rectAniamtion"];
}

- (CABasicAnimation *)drawRectWithLineColor:(CGColorRef)color animationValue:(NSString *)animationValue {
    CGPoint startPoint = [self triangleLeftPointWithScale:1.2];
    UIBezierPath *rectPath = [UIBezierPath bezierPath];
    [rectPath moveToPoint:startPoint];
    [rectPath addLineToPoint:CGPointMake(startPoint.x, startPoint.y - GCCircleRadius*2.4)];
    [rectPath addLineToPoint:CGPointMake(startPoint.x + powf(3, 0.5)*GCCircleRadius*1.2, startPoint.y - GCCircleRadius*2.4)];
    [rectPath addLineToPoint:CGPointMake(startPoint.x + powf(3, 0.5)*GCCircleRadius*1.2, startPoint.y - 2)];
    [rectPath addLineToPoint:CGPointMake(startPoint.x - 2.5, startPoint.y - 2)];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = rectPath.CGPath;
    layer.lineWidth = 5;
    layer.strokeColor = color;
    layer.fillColor = [UIColor clearColor].CGColor;
    [self addSublayer:layer];
    
    CABasicAnimation *rectAniamtion = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    rectAniamtion.fromValue = @(0.0);
    rectAniamtion.toValue = @(1.0);
    rectAniamtion.duration = 0.8;
    rectAniamtion.delegate = self;
    if (animationValue.length) {
        [rectAniamtion setValue:@"rectAniamtion" forKey:@"animationName"];
    }
    [layer addAnimation:rectAniamtion forKey:nil];
    
    return rectAniamtion;
}

#pragma mark - water animation
- (void)waterRose {
    NSMutableArray <UIBezierPath *> *waterPathArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 11; i++) {
        UIBezierPath *water = [self water:i % 2 == 0 ? YES : NO withProgress:0.1*i];
        [waterPathArray addObject:water];
    }
    self.waterLayer = [CAShapeLayer layer];
    self.waterLayer.path = [waterPathArray firstObject].CGPath;
    self.waterLayer.lineWidth = 5;
    self.waterLayer.strokeColor = [UIColor darkGrayColor].CGColor;
    self.waterLayer.fillColor = [UIColor darkGrayColor].CGColor;
    [self addSublayer:self.waterLayer];
    
    [self addWaterAnimation:waterPathArray];
}

- (void)addWaterAnimation:(NSMutableArray <UIBezierPath *> *)waterArray {
    NSMutableArray <CABasicAnimation *> *animationArray = [NSMutableArray array];
    for (NSInteger i = 0; i < waterArray.count - 1; i++) {
        CABasicAnimation *waterAniamtion = [CABasicAnimation animationWithKeyPath:@"path"];
        waterAniamtion.fromValue = (__bridge id _Nullable)(waterArray[i].CGPath);
        waterAniamtion.toValue = (__bridge id _Nullable)(waterArray[i + 1].CGPath);
        waterAniamtion.duration = 0.2;
        waterAniamtion.beginTime = i == 0 ? 0.0 : animationArray[i - 1].beginTime + animationArray[i - 1].duration;
        [animationArray addObject:waterAniamtion];
    }
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = animationArray;
    group.duration = [animationArray lastObject].beginTime + [animationArray lastObject].duration;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.delegate = self;
    [group setValue:@"waterAnimation" forKey:@"animationName"];
    [self.waterLayer addAnimation:group forKey:nil];
}

- (UIBezierPath *)water:(BOOL)leftUp withProgress:(CGFloat)progress {
    CGPoint startPoint = [self triangleLeftPointWithScale:1.2];
    CGPoint controlPoint1 = CGPointZero;
    CGPoint controlPoint2 = CGPointZero;
    if (leftUp) {
        controlPoint1 = CGPointMake(startPoint.x + powf(3, 0.5)*GCCircleRadius*1.2/4, startPoint.y - GCCircleRadius*2.4/2 - GCCircleRadius*progress);
        controlPoint2 = CGPointMake(startPoint.x + powf(3, 0.5)*GCCircleRadius*1.2/4*3, startPoint.y - GCCircleRadius*2.4/8 - GCCircleRadius*progress);
    } else {
        controlPoint1 = CGPointMake(startPoint.x + powf(3, 0.5)*GCCircleRadius*1.2/4, startPoint.y - GCCircleRadius*2.4/8 - GCCircleRadius*progress);
        controlPoint2 = CGPointMake(startPoint.x + powf(3, 0.5)*GCCircleRadius*1.2/4*3, startPoint.y - GCCircleRadius*2.4/2 - GCCircleRadius*progress);
    }
    UIBezierPath *water = [UIBezierPath bezierPath];
    [water moveToPoint:startPoint];
    if (progress != 0) {
        [water addLineToPoint:CGPointMake(startPoint.x, startPoint.y - GCCircleRadius*2.4*progress)];
        if (progress == 1) {
          [water addCurveToPoint:CGPointMake(startPoint.x + powf(3, 0.5)*GCCircleRadius*1.2, startPoint.y - GCCircleRadius*2.4*progress)
                     controlPoint1:CGPointMake(startPoint.x + powf(3, 0.5)*GCCircleRadius*1.2/4, startPoint.y - GCCircleRadius*2.4*progress)
                     controlPoint2:CGPointMake(startPoint.x + powf(3, 0.5)*GCCircleRadius*1.2/4*3, startPoint.y - GCCircleRadius*2.4*progress)];
        } else {
            [water addCurveToPoint:CGPointMake(startPoint.x + powf(3, 0.5)*GCCircleRadius*1.2, startPoint.y - GCCircleRadius*2.4*progress) controlPoint1:controlPoint1 controlPoint2:controlPoint2];
        }
        [water addLineToPoint:CGPointMake(startPoint.x + powf(3, 0.5)*GCCircleRadius*1.2, startPoint.y)];
        [water addLineToPoint:CGPointMake(startPoint.x - 2.5, startPoint.y)];
    } else {
        [water addLineToPoint:CGPointMake(startPoint.x + powf(3, 0.5)*GCCircleRadius*1.2, startPoint.y)];
    }
    
    return water;
}

#pragma mark - end animation
- (void)blowUpToFullScreen {
    UIBezierPath *screenPath = [UIBezierPath bezierPath];
    [screenPath moveToPoint:CGPointMake(GCLoadingLayerCenterX - GCDeviceWidth/2, GCLoadingLayerCenterY + GCDeviceHeight/2)];
    [screenPath addLineToPoint:CGPointMake(GCLoadingLayerCenterX - GCDeviceWidth/2, GCLoadingLayerCenterY - GCDeviceHeight/2)];
    [screenPath addLineToPoint:CGPointMake(GCLoadingLayerCenterX + GCDeviceWidth/2, GCLoadingLayerCenterY - GCDeviceHeight/2)];
    [screenPath addLineToPoint:CGPointMake(GCLoadingLayerCenterX + GCDeviceWidth/2, GCLoadingLayerCenterY + GCDeviceHeight/2)];
    [screenPath closePath];
    
    CABasicAnimation *blowUpAniamtion = [CABasicAnimation animationWithKeyPath:@"path"];
    blowUpAniamtion.toValue = (__bridge id _Nullable)(screenPath.CGPath);
    blowUpAniamtion.duration = 0.3;
    blowUpAniamtion.beginTime = 0.0;
    blowUpAniamtion.removedOnCompletion = NO;
    blowUpAniamtion.fillMode = kCAFillModeForwards;
    blowUpAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.waterLayer addAnimation:blowUpAniamtion forKey:nil];
}

- (void)showLogo {
    CALayer *logoLayer = [CALayer layer];
    logoLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"logo.jpg"].CGImage);
    
    logoLayer.frame = CGRectMake(GCLoadingLayerCenterX, GCLoadingLayerCenterY, 0, 0);
    [self addSublayer:logoLayer];
    
    CABasicAnimation *logoAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    logoAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(GCLoadingLayerCenterX, GCLoadingLayerCenterY, 100, 120)];
    logoAnimation.duration = 0.2;
    logoAnimation.beginTime = 0.0;
    logoAnimation.removedOnCompletion = NO;
    logoAnimation.fillMode = kCAFillModeForwards;
    [logoLayer addAnimation:logoAnimation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *animationName = [anim valueForKey:@"animationName"];
    if ([animationName isEqualToString:@"circleAnimation"]) {
        [self circleScaleAnimation];
    } else if ([animationName isEqualToString:@"circleScaleAnimation"]) {
        [self showTriangle];
    } else if ([animationName isEqualToString:@"triangleAniamtion"]) {
        [self rotateTriangle];
        [self dismissCircle];
    } else if ([animationName isEqualToString:@"rotationAniamtion"]) {
        [self drawBackgroundRectLine];
        [self performSelector:@selector(drawRectLine) withObject:nil afterDelay:0.3];
    } else if ([animationName isEqualToString:@"dismissAnimation"]) {
        [self.circleLayer removeFromSuperlayer];
    } else if ([animationName isEqualToString:@"rectAniamtion"]) {
        [self waterRose];
    } else if ([animationName isEqualToString:@"waterAnimation"]) {
        [self blowUpToFullScreen];
        [self performSelector:@selector(showLogo) withObject:nil afterDelay:0.2];
    }
}

@end
