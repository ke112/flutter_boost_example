//
//  MyFlutterBoostDelegate.m
//  Runner
//
//  Created by wubian on 2021/1/21.
//  Copyright © 2021 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyFlutterBoostDelegate.h"
#import "UIViewControllerDemo.h"
#import <flutter_boost/FlutterBoost.h>

@implementation MyFlutterBoostDelegate

//flutter跳转原生时,走这里
//如果框架发现您输入的路由表在flutter里面注册的路由表中找不到，那么就会调用此方法来push一个纯原生页面
- (void)pushNativeRoute:(NSString *)pageName arguments:(NSDictionary *) arguments {
    BOOL animated = [arguments[@"animated"] boolValue];
    BOOL present= [arguments[@"present"] boolValue];
    UIViewControllerDemo *nvc;
    if ([pageName isEqualToString:@"native"]) {
        nvc = [[UIViewControllerDemo alloc] initWithNibName:@"UIViewControllerDemo" bundle:[NSBundle mainBundle]];
    }
    if (nvc == nil){
        NSLog(@"路由表中找不到");
        return;
    }
    self.navigationController.customHiddenNavigationBar = NO;
    if (present){
        [self.navigationController presentViewController:nvc animated:animated completion:^{}];
    }else{
        [self.navigationController pushViewController:nvc animated:animated];
    }
}

//当框架的withContainer为true的时候，会调用此方法来做原生的push
- (void)pushFlutterRoute:(FlutterBoostRouteOptions *)options {
    FBFlutterViewContainer *vc = FBFlutterViewContainer.new;
    [vc setName:options.pageName uniqueId:options.uniqueId params:options.arguments opaque:options.opaque];
    
    //是否伴随动画
    BOOL animated = [options.arguments[@"animated"] boolValue];
    //是否是present的方式打开,如果要push的页面是透明的，那么也要以present形式打开
    BOOL present = [options.arguments[@"present"] boolValue] || !options.opaque;
    
    self.navigationController.customHiddenNavigationBar = YES;
    if (present){
        [self.navigationController presentViewController:vc animated:animated completion:^{
            options.completion(YES);
        }];
    } else{
        [self.navigationController pushViewController:vc animated:animated];
        options.completion(YES);
    }
}

//当pop调用涉及到原生容器的时候，此方法将会被调用
- (void)popRoute:(FlutterBoostRouteOptions *)options {
    //拿到当前vc
    FBFlutterViewContainer *vc = (id)self.navigationController.presentedViewController;
    
    //是否伴随动画,默认是true
    BOOL animated = true;
    NSNumber *animatedValue = options.arguments[@"animated"];
    if (animatedValue){
        animated = [animatedValue boolValue];
    }

    //present的情况，走dismiss逻辑
    if ([vc isKindOfClass:FBFlutterViewContainer.class] && [vc.uniqueIDString isEqual: options.uniqueId]){
        //这里分为两种情况，由于UIModalPresentationOverFullScreen下，生命周期显示会有问题
        //所以需要手动调用的场景，从而使下面底部的vc调用viewAppear相关逻辑
        if(vc.modalPresentationStyle == UIModalPresentationOverFullScreen){
            
            //这里手动beginAppearanceTransition触发页面生命周期
            [self.navigationController.topViewController beginAppearanceTransition:YES animated:NO];
            
            [vc dismissViewControllerAnimated:YES completion:^{
                [self.navigationController.topViewController endAppearanceTransition];
            }];
        }else{
            //正常场景，直接dismiss
            [vc dismissViewControllerAnimated:YES completion:^{}];
        }
    } else{
        //否则走pop逻辑
        [self.navigationController popViewControllerAnimated:animated];
    }
    
    options.completion(YES);
}


+ (void)pushFlutterPage:(NSString *)pageName arguments:(NSDictionary *)arguments{
    FlutterBoostRouteOptions *options = [[FlutterBoostRouteOptions alloc] init];
    options.pageName = pageName;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:arguments];
    [param setValue:@(YES) forKey:@"animated"];
    [param setValue:@(NO) forKey:@"present"];
    options.arguments = param;
    
    //open方法完成后的回调
    options.completion = ^(BOOL completion) {
        
    };
    //参数回传的回调闭包
    options.onPageFinished = ^(NSDictionary *res) {
        
    };
    [[FlutterBoost instance] open:options];
}


@end





//class BoostDelegate: NSObject,FlutterBoostDelegate {
//
//    ///您用来push的导航栏
//    var navigationController:UINavigationController?
//
//    ///用来存返回flutter侧返回结果的表
//    var resultTable:Dictionary<String,([AnyHashable:Any]?)->Void> = [:];
//
//    func pushNativeRoute(_ pageName: String!, arguments: [AnyHashable : Any]!) {
//
//        //可以用参数来控制是push还是pop
//        let isPresent = arguments["isPresent"] as? Bool ?? false
//        let isAnimated = arguments["isAnimated"] as? Bool ?? true
//        //这里根据pageName来判断生成哪个vc，这里给个默认的了
//        var targetViewController = UIViewController()
//
//        if(isPresent){
//            self.navigationController?.present(targetViewController, animated: isAnimated, completion: nil)
//        }else{
//            self.navigationController?.pushViewController(targetViewController, animated: isAnimated)
//        }
//    }
//
//    func pushFlutterRoute(_ options: FlutterBoostRouteOptions!) {
//        let vc:FBFlutterViewContainer = FBFlutterViewContainer()
//        vc.setName(options.pageName, uniqueId: options.uniqueId, params: options.arguments,opaque: options.opaque)
//
//        //用参数来控制是push还是pop
//        let isPresent = (options.arguments?["isPresent"] as? Bool)  ?? false
//        let isAnimated = (options.arguments?["isAnimated"] as? Bool) ?? true
//
//        //对这个页面设置结果
//        resultTable[options.pageName] = options.onPageFinished;
//
//        //如果是present模式 ，或者要不透明模式，那么就需要以present模式打开页面
//        if(isPresent || !options.opaque){
//            self.navigationController?.present(vc, animated: isAnimated, completion: nil)
//        }else{
//            self.navigationController?.pushViewController(vc, animated: isAnimated)
//        }
//    }
//
//    func popRoute(_ options: FlutterBoostRouteOptions!) {
//        //如果当前被present的vc是container，那么就执行dismiss逻辑
//        if let vc = self.navigationController?.presentedViewController as? FBFlutterViewContainer,vc.uniqueIDString() == options.uniqueId{
//
//            //这里分为两种情况，由于UIModalPresentationOverFullScreen下，生命周期显示会有问题
//            //所以需要手动调用的场景，从而使下面底部的vc调用viewAppear相关逻辑
//            if vc.modalPresentationStyle == .overFullScreen {
//
//                //这里手动beginAppearanceTransition触发页面生命周期
//                self.navigationController?.topViewController?.beginAppearanceTransition(true, animated: false)
//
//                vc.dismiss(animated: true) {
//                    self.navigationController?.topViewController?.endAppearanceTransition()
//                }
//            }else{
//                //正常场景，直接dismiss
//                vc.dismiss(animated: true, completion: nil)
//            }
//        }else{
//            self.navigationController?.popViewController(animated: true)
//        }
//        //否则直接执行pop逻辑
//        //这里在pop的时候将参数带出,并且从结果表中移除
//        if let onPageFinshed = resultTable[options.pageName] {
//            onPageFinshed(options.arguments)
//            resultTable.removeValue(forKey: options.pageName)
//        }
//    }
//}
