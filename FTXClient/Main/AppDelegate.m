//
//  AppDelegate.m
//  FTXClient
//
//  Created by Lei Perry on 6/18/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "AppDelegate.h"
#import "MobClick.h"
#import "UMSocial.h"
#import <Crashlytics/Crashlytics.h>
#import "HomeViewController.h"
#import "WXApi.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"ed27e953e56c4a8fa6bda4ad36bc6fbcbdbdc449"];
    [MobClick startWithAppkey:kUMengAppKey];
    [UMSocialData setAppKey:kUMengAppKey];
    
    // wechat
    [WXApi registerApp:@"wx62c0b969df327319"];
    [UMSocialControllerService defaultControllerService].socialData.extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    [UMSocialData defaultData].extConfig.appUrl = @"http://www.umeng.com";
    
    [self setupUserDefaults];
    [[DataManager sharedManager] checkDatabase];
    
    _navigationController = [[UINavigationController alloc] initWithRootViewController:[HomeViewController sharedHome]];
    UINavigationBar *navigationBar = [_navigationController navigationBar];
    if ([navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation-bar-bg"] forBarMetrics:UIBarMetricsDefault];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _navigationController;
    [self.window makeKeyAndVisible];
    
    int loginType = [UserDefaults integerForKey:kUCLoginType];
    if (loginType > -1) {
        [[DataManager sharedManager] loginVia:loginType
                                withAccountId:[UserDefaults stringForKey:kUCLoginAccountId]
                                  andPassword:[UserDefaults stringForKey:kUCLoginPassword]
                                  andNickName:[UserDefaults stringForKey:kUCLoginPassword]
                            popViewController:nil];
    }
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UMSocialSnsService applicationDidBecomeActive];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void)setupUserDefaults {
    NSDictionary *dict = @{kUCLoginType: @-1};
    [UserDefaults registerDefaults:dict];
    [UserDefaults synchronize];
}

@end