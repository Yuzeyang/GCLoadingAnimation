//
//  ViewController.m
//  GCLoadingAnimationOne
//
//  Created by 宫城 on 16/7/25.
//  Copyright © 2016年 宫城. All rights reserved.
//

#import "ViewController.h"
#import "GCLoadingLayer.h"

#define GCDeviceWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define GCDeviceHeight CGRectGetHeight([UIScreen mainScreen].bounds)

#define GCLoadingLayerCenterX GCDeviceWidth/2
#define GCLoadingLayerCenterY GCDeviceHeight/2

@interface ViewController ()

@property (nonatomic, strong) GCLoadingLayer *loadingLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self showLoadingLayer];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)restart:(id)sender {
    [self.loadingLayer removeFromSuperlayer];
    [self showLoadingLayer];
}

- (void)showLoadingLayer {
    self.loadingLayer = [GCLoadingLayer layer];
    self.loadingLayer.frame = CGRectMake(GCLoadingLayerCenterX, GCLoadingLayerCenterY, 100, 100);
    [self.view.layer addSublayer:self.loadingLayer];
    [self.loadingLayer startAnimation];
}

@end
