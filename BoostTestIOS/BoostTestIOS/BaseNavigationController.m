//
//  BaseNavigationController.m
//  BoostTestIOS
//
//  Created by ke on 2023/1/4.
//

#import "BaseNavigationController.h"

#define kColorWithHex(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0f green:((c>>8)&0xFF)/255.0f blue:(c&0xFF)/255.0f alpha:1.0f]

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController


- (UIStatusBarStyle)preferredStatusBarStyle {
    UIStatusBarStyle style = self.topViewController.preferredStatusBarStyle;
    return style;
}

- (BOOL)shouldAutorotate {
    BOOL s = self.topViewController.shouldAutorotate;
    return s;
}

//设置支持的屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

//设置presentation方式展示的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    
    // 标题
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, [UIFont systemFontOfSize:18 weight:UIFontWeightMedium], NSFontAttributeName, nil]];
    
    // kColorWithHex(0x2c2c2c)
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = [UIColor systemBlueColor];
    self.view.backgroundColor = [UIColor systemBlueColor];
}

//重写push后返回按钮的文字,文字可以为空字符串.
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //修改返回文字
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    //全部修改返回按钮,但是会失去右滑返回的手势
//    if (viewController.navigationItem.leftBarButtonItem == nil && self.viewControllers.count >=1) {
//        viewController.navigationItem.leftBarButtonItem = [self creatBackButton];
//    }
//
    [super pushViewController:viewController animated:animated];
}

- (UIBarButtonItem *)creatBackButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[[UIImage imageNamed:@"icon_back_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    btn.bounds = CGRectMake(0, 0, 20, 20);
//    btn.backgroundColor = [UIColor greenColor];
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
    
}
- (void)popSelf{
    [self popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    //设置导航栏背景图片为一个空的image，这样就透明了
//    [self.navigationBar setBackgroundImage:[[UIImage alloc] init]     forBarMetrics:UIBarMetricsDefault];
//    //去掉透明后导航栏下边的黑边
//    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //如果不想让其他页面的导航栏变为透明 需要重置
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
}

@end
