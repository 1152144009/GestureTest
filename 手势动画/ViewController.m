//
//  ViewController.m
//  手势动画
//
//  Created by dianzhi1 on 17/5/19.
//  Copyright © 2017年 dianzhi1. All rights reserved.
//

#import "ViewController.h"
#import "TouchView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TouchView *tou = [[TouchView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    tou.backgroundColor = [UIColor redColor];
    [self.view addSubview:tou];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
