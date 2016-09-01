//
//  ViewController.m
//  GCLoadingAnimationTwo
//
//  Created by 宫城 on 16/8/29.
//  Copyright © 2016年 宫城. All rights reserved.
//

#import "ViewController.h"
#import "GCLoadingView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GCLoadingView *loadingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
