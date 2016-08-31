//
//  UIView+GCAddition.m
//  GCLoadingAnimationTwo
//
//  Created by 宫城 on 16/8/31.
//  Copyright © 2016年 宫城. All rights reserved.
//

#import "UIView+GCAddition.h"

@implementation UIView (GCAddition)

- (CGPoint)gc_centerWithIsAnimating:(BOOL)isAnimating {
    if (isAnimating) {
        return ((CALayer *)self.layer.presentationLayer).position;
    } else {
        return self.center;
    }
}

@end
