//
//  AccessAccountViewController.m
//  FTXClient
//
//  Created by Lei Perry on 6/22/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "AccessAccountViewController.h"

@interface AccessAccountViewController ()

@end

@implementation AccessAccountViewController

- (id)initWithLogin:(BOOL)isLogin {
    if (self = [super init]) {
        _isLogin = isLogin;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _loginView = [[LoginView alloc] initWithFrame:self.view.bounds];
    _loginView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _registerView = [[RegisterView alloc] initWithFrame:self.view.bounds];
    _registerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (_isLogin) {
        [self.view addSubview:_registerView];
        [self.view addSubview:_loginView];
    }
    else {
        [self.view addSubview:_loginView];
        [self.view addSubview:_registerView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.title = _isLogin ? @"登录" : @"注册";
}

- (void)loginAction {
    DLog(@"login");
}

- (void)registerAction {
    DLog(@"register");
}

- (void)switchLoginAndRegister {
    _isLogin = !_isLogin;
    if (_isLogin) {
        [UIView transitionFromView:_registerView
                            toView:_loginView
                          duration:.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished){
                           self.title = @"登录";
                        }];
    }
    else {
        [UIView transitionFromView:_loginView
                            toView:_registerView
                          duration:.5
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL finished){
                            self.title = @"注册";
                        }];

    }
}

@end