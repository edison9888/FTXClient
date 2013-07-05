//
//  AccessAccountViewController.m
//  FTXClient
//
//  Created by Lei Perry on 6/22/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UMSocial.h"

@interface AccessAccountViewController ()

@end

@implementation AccessAccountViewController

- (void)loadView {
    [super loadView];
    
    _loginView = [[LoginView alloc] initWithFrame:self.view.bounds];
    _loginView.controller = self;
    _loginView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _registerView = [[RegisterView alloc] initWithFrame:self.view.bounds];
    _registerView.controller = self;
    _registerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _myAccountView = [[MyAccountView alloc] initWithFrame:self.view.bounds];
    _myAccountView.controller = self;
    _myAccountView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_myAccountView populateInterface];
    
    if ([[DataManager sharedManager].currentAccount success]) {
        [self.view addSubview:_loginView];
        [self.view addSubview:_registerView];
        [self.view addSubview:_myAccountView];
    }
    else {
        [self.view addSubview:_myAccountView];
        [self.view addSubview:_registerView];
        [self.view addSubview:_loginView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
    UMSocialAccountEntity *sinaAccount = [snsAccountDic valueForKey:UMShareToSina];
    UMSocialAccountEntity *qqAccount = [snsAccountDic valueForKey:UMShareToQzone];
    DLog(@"sina nickName is %@, iconURL is %@", sinaAccount.userName, sinaAccount.iconURL);
    DLog(@"qq nickName is %@, iconURL is %@", qqAccount.userName, qqAccount.iconURL);
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
    self.title = [[DataManager sharedManager].currentAccount success] ? @"我的账号" : @"登录";
    
    [[NSNotificationCenter defaultCenter] addObserver:_myAccountView selector:@selector(populateInterface) name:kAccountChangeNotification object:[DataManager sharedManager]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_myAccountView.tableView deselectRowAtIndexPath:[_myAccountView.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:_myAccountView name:kAccountChangeNotification object:[DataManager sharedManager]];
}

- (void)switchToView:(AccountViewType)viewType {
    UIView *fromView = self.view.subviews[self.view.subviews.count - 1];
    UIView *toView;
    NSString *title;
    UIViewAnimationOptions animation;
    switch (viewType) {
        case AccountViewTypeLogin: {
            toView = _loginView;
            title = @"登录";
            animation = UIViewAnimationOptionTransitionFlipFromLeft;
        }
            break;
        case AccountViewTypeRegister: {
            toView = _registerView;
            title = @"注册";
            animation = UIViewAnimationOptionTransitionFlipFromRight;
        }
            break;
        case AccountViewTypeProfile: {
            toView = _myAccountView;
            title = @"我的账户";
            animation = UIViewAnimationOptionTransitionNone;
        }
            break;
    }
    
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:.5
                       options:animation
                    completion:^(BOOL finished){
                        self.title = title;
                    }];
}

- (void)tapLeftBarButton {
    [self.navigationController popViewControllerAnimated:YES];
}

@end