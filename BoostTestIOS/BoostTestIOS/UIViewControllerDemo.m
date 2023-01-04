//
//  UIViewControllerDemo.m
//  Runner
//
//  Created by Jidong Chen on 2018/10/17.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "UIViewControllerDemo.h"
#import "MyFlutterBoostDelegate.h"


@interface UIViewControllerDemo ()

@end

@implementation UIViewControllerDemo


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"iOS原生标题";
}

- (IBAction)pushFlutterPage:(id)sender {
    [MyFlutterBoostDelegate pushFlutterPage:@"mainPage" arguments:@{@"userId":@"12345"}];
}


@end
