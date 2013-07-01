//
//  AccessAccountViewController.h
//  FTXClient
//
//  Created by Lei Perry on 6/22/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import "LoginView.h"
#import "RegisterView.h"
#import "MyAccountView.h"

@interface AccessAccountViewController : UIViewController
{
    LoginView *_loginView;
    RegisterView *_registerView;
    MyAccountView *_myAccountView;
}

- (void)switchToView:(AccountViewType)viewType;

@end