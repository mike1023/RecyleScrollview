//
//  ViewController.m
//  RecyleScrollView
//
//  Created by glf on 2018/1/9.
//  Copyright © 2018年 glf. All rights reserved.
//

#import "ViewController.h"
#import "JSPRecycleview.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JSPRecycleview * jspV = [[JSPRecycleview alloc] initWithFrame:CGRectMake(20, 100, 300, 200)];
    jspV.imgArr = @[@"1.png", @"2.png", @"3.png", @"4.png"];
    jspV.autoScroll = YES;
    [self.view addSubview:jspV];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
