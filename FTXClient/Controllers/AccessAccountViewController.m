//
//  AccessAccountViewController.m
//  FTXClient
//
//  Created by Lei Perry on 6/22/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UMSocial.h"
#import "UIView+FTX.h"

@interface AccessAccountViewController ()
{
    UIToolbar *_keyboardToolbar;
}
@end

@implementation AccessAccountViewController

- (id)init {
    if (self = [super init]) {
        _loginView = [[LoginView alloc] init];
        _loginView.controller = self;
        _loginView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _registerView = [[RegisterView alloc] init];
        _registerView.controller = self;
        _registerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _myAccountView = [[MyAccountView alloc] init];
        _myAccountView.controller = self;
        _myAccountView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _loginView.frame = self.view.bounds;
    _registerView.frame = self.view.bounds;
    _myAccountView.frame = self.view.bounds;
    
    if ([DataMgr.currentAccount success]) {
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
    self.title = [DataMgr.currentAccount success] ? @"我的账号" : @"登录";
    
    [_myAccountView populateInterface];
    [[NSNotificationCenter defaultCenter] addObserver:_myAccountView selector:@selector(populateInterface) name:kAccountChangeNotification object:DataMgr];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [_myAccountView.tableView deselectRowAtIndexPath:[_myAccountView.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:_myAccountView name:kAccountChangeNotification object:DataMgr];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    _keyboardToolbar = nil;
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
    _keyboardToolbar = nil;
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

- (void)dismissKeyboard:(id)sender
{
	[[self.view findFirstResponder] resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect beginRect = [[[notification userInfo] valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    DLog(@"%@", NSStringFromCGRect(endRect));
    
	if (nil == _keyboardToolbar) {
        _keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        _keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];
        dismissButton.tintColor = [UIColor blueColor];
        
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        NSArray *items = [[NSArray alloc] initWithObjects:flex, dismissButton, nil];
        [_keyboardToolbar setItems:items];
        
        _keyboardToolbar.frame = CGRectMake(beginRect.origin.x,
                                            beginRect.origin.y,
                                            _keyboardToolbar.frame.size.width,
                                            _keyboardToolbar.frame.size.height);
        [self.view addSubview:_keyboardToolbar];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    _keyboardToolbar.frame = CGRectMake(endRect.origin.x,
                                        endRect.origin.y-108,
                                        _keyboardToolbar.frame.size.width,
                                        _keyboardToolbar.frame.size.height);
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect endRect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    _keyboardToolbar.frame = CGRectMake(endRect.origin.x,
                                        endRect.origin.y,
                                        _keyboardToolbar.frame.size.width,
                                        _keyboardToolbar.frame.size.height);
    [UIView commitAnimations];
}

@end