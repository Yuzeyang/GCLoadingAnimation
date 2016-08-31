//
//  GCLoadingCircle.h
//  GCLoadingAnimationTwo
//
//  Created by 宫城 on 16/8/31.
//  Copyright © 2016年 宫城. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGCLoadingCircleRadius 20

@interface GCLoadingCircle : UIView

- (void)setProgess:(CGFloat)progess;
- (void)startLoading;

@end
