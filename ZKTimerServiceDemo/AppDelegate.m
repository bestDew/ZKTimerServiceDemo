//
//  AppDelegate.m
//  ZKTimerServiceDemo
//
//  Created by bestdew on 2019/3/4.
//  Copyright © 2019 bestdew. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "DiscoverViewController.h"
#import "ZKTimerService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    HomeViewController *homeVC = [HomeViewController new];
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
    homeVC.navigationItem.title = @"Home";
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    DiscoverViewController *discoverVC = [DiscoverViewController new];
    discoverVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Discover" image:[UIImage imageNamed:@"tabbar_discover"] selectedImage:[UIImage imageNamed:@"tabbar_discover_selected"]];
    discoverVC.navigationItem.title = @"Discover";
    UINavigationController *discoverNav = [[UINavigationController alloc] initWithRootViewController:discoverVC];
    
    UITabBarController *tabBarCtl = [[UITabBarController alloc] init];
    tabBarCtl.viewControllers = @[homeNav, discoverNav];
    
    _window.rootViewController = tabBarCtl;
    [_window makeKeyAndVisible];
    
    // 开启时间同步，直接从 NTP 服务器获取世界标准时间，避免受本地时间不准或被修改的影响
    [ZKTimerService timeSynchronization];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
