//
//  AppDelegate.m
//  BoostTestIOS
//
//  Created by ke on 2023/1/3.
//

#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "MyFlutterBoostDelegate.h"
#import <flutter_boost/FlutterBoost.h>
#import "BaseNavigationController.h"
#import "UIViewControllerDemo.h"

@interface AppDelegate ()

@end

static AppDelegate *_appDelegate;

@implementation AppDelegate

+ (AppDelegate *)appDelegate {
    return _appDelegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //boost默认方法
    MyFlutterBoostDelegate *delegate = [[MyFlutterBoostDelegate alloc] init];
    [[FlutterBoost instance] setup:application delegate:delegate callback:^(FlutterEngine *engine) {
        
    }];
    
    //设置root窗口
    UIViewControllerDemo *vc = [[UIViewControllerDemo alloc] initWithNibName:@"UIViewControllerDemo" bundle:[NSBundle mainBundle]];
    BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:vc];
    delegate.navigationController = navi;
    self.window.rootViewController = navi;
    

    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}



@end
