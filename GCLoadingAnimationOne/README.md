# **GCLoadingAnimationOne**

## Introduction

This is a loading animation

## Gif

the triangle has a rotate anmation,but the gif can't show it…you can run the demo see the effect.

![](https://github.com/Yuzeyang/GCLoadingAnimationOne/raw/master/GCLoadingAnimationOne.gif)

## how to use

add `GCLoadingLayer` in your view,and set the frame,then `startAnimation`

```objective-c
self.loadingLayer = [GCLoadingLayer layer];
self.loadingLayer.frame = CGRectMake(GCLoadingLayerCenterX, GCLoadingLayerCenterY, 100, 100);
[self.view.layer addSublayer:self.loadingLayer];
[self.loadingLayer startAnimation];
```

