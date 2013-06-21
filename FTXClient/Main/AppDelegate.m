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

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"ed27e953e56c4a8fa6bda4ad36bc6fbcbdbdc449"];
    [MobClick startWithAppkey:@"51c003b256240b556b0c7b80"];
    [UMSocialData setAppKey:@"51c003b256240b556b0c7b80"];
    
    [self setupUserDefaults];
    
    
    HomeViewController *rootVC = [[HomeViewController alloc] init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:rootVC];
    UINavigationBar *navigationBar = [_navigationController navigationBar];
    if ([navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation-bar-bg"] forBarMetrics:UIBarMetricsDefault];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupUserDefaults {
}

@end