//
//  AppUtility.m
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 19..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import "AppUtility.h"

@implementation AppUtility

+ (NSString *)textLocalizing:(NSString *)text {
    
    NSString *localizing = Localize(text, @"", nil);
    return localizing;
}

+ (UIViewController *)getRootTopMostViewController {
    
    UIViewController *topMostViewController = nil;
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if (rootViewController.presentedViewController) {
        
        topMostViewController = rootViewController.presentedViewController;
    } else if([rootViewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        topMostViewController = navigationController.visibleViewController;
    } else if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        topMostViewController = tabBarController.selectedViewController;
    } else {
        topMostViewController = rootViewController;
    }
    return topMostViewController;
}

@end
