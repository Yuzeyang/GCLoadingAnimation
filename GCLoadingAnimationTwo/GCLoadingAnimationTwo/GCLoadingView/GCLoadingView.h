//
//  GCLoadingView.h
//  GCLoadingAnimationTwo
//
//  Created by 宫城 on 16/8/29.
//  Copyright © 2016年 宫城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCLoadingView : UIView

/**
 *  初始化加载视图
 *
 *  @param scrollView       目标视图
 *  @param hasNavigationBar 是否有导航栏
 *
 *  @return instancetype
 */
- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

/**
 *  添加加载中回调
 *
 *  @param block 加载中回调，做加载请求操作
 */
- (void)addLoadingBlock:(void(^)())block;

/**
 *  停止加载
 */
- (void)stopLoading;

@end
