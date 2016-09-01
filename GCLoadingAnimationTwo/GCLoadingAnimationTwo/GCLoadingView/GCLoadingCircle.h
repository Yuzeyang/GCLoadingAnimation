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

/**
 *  设定圆圈显示进度
 *
 *  @param progess 进度
 */
- (void)setProgess:(CGFloat)progess;

/**
 *  开始加载动画
 */
- (void)startLoading;

/**
 *  停止加载动画
 */
- (void)stopLoading;

@end
