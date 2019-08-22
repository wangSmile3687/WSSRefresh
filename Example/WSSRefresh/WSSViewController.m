//
//  WSSViewController.m
//  WSSRefresh
//
//  Created by 18566663687@163.com on 08/22/2019.
//  Copyright (c) 2019 18566663687@163.com. All rights reserved.
//

#import "WSSViewController.h"
#import "HViewController.h"
#import "VViewController.h"
@interface WSSViewController ()

@end

@implementation WSSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *hBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hBtn.frame = CGRectMake(100, 100, 200, 50);
    hBtn.backgroundColor = [UIColor redColor];
    [hBtn setTitle:@"水平方向刷新" forState:UIControlStateNormal];
    [hBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [hBtn addTarget:self action:@selector(hBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hBtn];
    
    UIButton *vBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    vBtn.frame = CGRectMake(100, 300, 200, 50);
    vBtn.backgroundColor = [UIColor redColor];
    [vBtn setTitle:@"上下方向刷新" forState:UIControlStateNormal];
    [vBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [vBtn addTarget:self action:@selector(vBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:vBtn];
}

- (void)hBtnClick {
    HViewController *vc = [[HViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)vBtnClick {
    VViewController *vc = [[VViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
}

@end
