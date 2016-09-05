# **GCLoadingAnimationTwo**

## Introduction

This is a loading animation

## Gif

![](https://github.com/Yuzeyang/GCLoadingAnimation/blob/master/GCLoadingAnimationTwo/GCLoadingAnimationTwo.gif)

## how to use

add `GCLoadingView` in your scrollView,and add `loadingBlock`,then when finish loading, call the `stopLoading` method

```objective-c
self.loadingView = [[GCLoadingView alloc] initWithScrollView:self.tableView];
__weak __typeof(&*self)weakSelf = self;
[self.loadingView addLoadingBlock:^{
    // do some net work

    // mock after 3 seconds stop loadiing
    int64_t delta = 3;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delta * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [weakSelf.loadingView stopLoading];
    });
}];
[self.view addSubview:self.loadingView];
```

## Related articles

[果冻效果下拉刷新控件](http://zeeyang.com/2016/09/02/loadingAniamtion-0902/)