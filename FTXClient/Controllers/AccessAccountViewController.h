//
//  AccessAccountViewController.h
//  FTXClient
//
//  Created by Lei Perry on 6/22/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import "LoginView.h"
#import "RegisterView.h"

@interface AccessAccountViewController : UIViewController
{
    LoginView *_loginView;
    RegisterView *_registerView;
    BOOL _isLogin;
}

- (id)initWithLogin:(BOOL)isLogin;

- (void)loginAction;
- (void)registerAction;
- (void)switchLoginAndRegister;

@end