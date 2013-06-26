//
//  AccessAccountViewController.m
//  FTXClient
//
//  Created by Lei Perry on 6/22/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect buttonRect = CGRectMake(0, 0, 44, 44);
    buttonRect = CGRectInset(buttonRect, 4, 4);
    
    // left bar button
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton setImage:[UIImage imageNamed:@"icon-back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(tapLeftBarButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *leftView = [[UIView alloc] initWithFrame:buttonRect];
    leftView.backgroundColor = [UIColor colorWithWhite:1 alpha:.12];
    leftView.layer.cornerRadius = 5;
    [leftView addSubview:leftButton];
    leftButton.center = CGPointMake(CGRectGetWidth(buttonRect)/2, CGRectGetHeight(buttonRect)/2);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    
    // title
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

- (void)tapLeftBarButton {
    [self.navigationController popViewControllerAnimated:YES];
}

@end