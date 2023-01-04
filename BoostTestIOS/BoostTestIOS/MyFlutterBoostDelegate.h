//
//  MyFlutterBoostDelegate.h
//  Runner
//
//  Created by wubian on 2021/1/21.
//  Copyright © 2021 The Chromium Authors. All rights reserved.
//
#import <flutter_boost/FlutterBoost.h>
#import <Foundation/Foundation.h>
#import "BaseNavigationController.h"

@interface MyFlutterBoostDelegate : NSObject<FlutterBoostDelegate>
    
@property (nonatomic,strong) BaseNavigationController *navigationController;

/// 跳转到flutter界面
/// - Parameters:
///   - pageName: 界面标识
///   - arguments: 界面参数
+ (void)pushFlutterPage:(NSString *)pageName arguments:(NSDictionary *)arguments;

@end
