//
//  RegisterView.m
//  FTXClient
//
//  Created by Lei Perry on 6/23/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "RegisterView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+FTX.h"
#import "UIColor+FTX.h"
#import "AccessAccountViewController.h"
#import "CustomIconButton.h"
#import "NetWorkReachability.h"
#import "AFFTXAPIClient.h"
#import "Account.h"
#import "DataManager.h"
#import "HomeViewController.h"

#define kAgreeButtonTag 1

@interface RegisterView ()
{
    UITextField *mailField, *userField, *passField;
    CustomIconButton *agreeButton;
}

@end

@implementation RegisterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        mailField = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, 260, 44)];
        mailField.delegate = self;
        mailField.keyboardType = UIKeyboardTypeEmailAddress;
        mailField.placeholder = @"常用邮箱@";
        mailField.textAlignment = UITextAlignmentCenter;
        mailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        mailField.layer.backgroundColor = [UIColor whiteColor].CGColor;
        mailField.layer.cornerRadius = 4;
        [self addSubview:mailField];

        userField = [[UITextField alloc] initWithFrame:CGRectMake(30, 84, 260, 44)];
        userField.delegate = self;
        userField.placeholder = @"昵称";
        userField.textAlignment = UITextAlignmentCenter;
        userField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        userField.layer.backgroundColor = [UIColor whiteColor].CGColor;
        userField.layer.cornerRadius = 4;
        [self addSubview:userField];

        passField = [[UITextField alloc] initWithFrame:CGRectMake(30, 138, 260, 44)];
        passField.delegate = self;
        passField.placeholder = @"密码";
        passField.secureTextEntry = YES;
        passField.textAlignment = UITextAlignmentCenter;
        passField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        passField.layer.backgroundColor = [UIColor whiteColor].CGColor;
        passField.layer.cornerRadius = 4;
        [self addSubview:passField];
        
        agreeButton = [CustomIconButton buttonWithType:UIButtonTypeCustom];
        agreeButton.imageOriginX = 0;
        agreeButton.titleOriginX = 20;
        agreeButton.frame = CGRectMake(30, 182, 200, 44);
        agreeButton.tag = kAgreeButtonTag;
        agreeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [agreeButton addTarget:self action:@selector(toggleAgreeButton:) forControlEvents:UIControlEventTouchUpInside];
        [agreeButton setImage:[UIImage imageNamed:@"button-normal-state"] forState:UIControlStateNormal];
        [agreeButton setImage:[UIImage imageNamed:@"button-selected-state"] forState:UIControlStateSelected];
        [agreeButton setTitle:@"同意饭特稀协议" forState:UIControlStateNormal];
        [agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:agreeButton];
        
        UIButton *regButton = [UIButton buttonWithType:UIButtonTypeCustom];
        regButton.frame = CGRectMake(30, 226, 125, 44);
        regButton.layer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button-gray-bg"]].CGColor;
        regButton.layer.cornerRadius = 4;
        [regButton setTitle:@"注册" forState:UIControlStateNormal];
        [regButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [regButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:regButton];
        
        UIButton *goLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        goLoginButton.frame = CGRectMake(165, 226, 125, 44);
        goLoginButton.layer.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"button-gray-bg"] imageTintedWithColor:[UIColor colorWithHex:0xd24b00]]].CGColor;
        goLoginButton.layer.cornerRadius = 4;
        [goLoginButton setTitle:@"登录" forState:UIControlStateNormal];
        [goLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [goLoginButton addTarget:_controller action:@selector(switchLoginAndRegister) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:goLoginButton];
        
        CGRect rect = [UIScreen mainScreen].applicationFrame;
        self.contentSize = CGSizeMake(320, CGRectGetHeight(rect)-44+74);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)toggleAgreeButton:(UIButton *)button {
    button.selected = !button.selected;
}

- (void)registerAction {
    // check mail address
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    if ([emailTest evaluateWithObject:mailField.text] == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入正确的邮箱地址" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [mailField becomeFirstResponder];
        return;
    }
    
    // check nickname
    if ([userField.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入昵称" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [userField becomeFirstResponder];
        return;
    }

    // check password
    if ([passField.text length] < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"密码长度不能少于6位" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [passField becomeFirstResponder];
        return;
    }
    
    // check agreement
    if (agreeButton.selected == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"必须同意饭特稀协议才能完成注册" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }

    if ([NetworkReachability sharedReachability].reachable) {
        [[AFFTXAPIClient sharedClient] getPath:[NSString stringWithFormat:@"/app/user/register?accountId=%@&nickName=%@&password=%@&sourceId=0", mailField.text, userField.text, passField.text]
                                    parameters:nil
                                       success:^(AFHTTPRequestOperation *operation, id JSON) {
                                           DLog(@"success: %@", JSON);
                                           Account *account = [[Account alloc] initWithAttributes:JSON];
                                           if (!account.success) {
                                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:account.msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                               [alert show];
                                           }
                                           else {
                                               [DataManager sharedManager].currentAccount = account;
                                               [[HomeViewController sharedHome].navigationController popViewControllerAnimated:YES];
                                               
                                               [UserDefaults setValue:mailField.text forKey:kUCAccountId];
                                               [UserDefaults setValue:passField.text forKey:kUCAccountPwd];
                                               [UserDefaults synchronize];
                                           }
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           DLog(@"error: %@", [error description]);
                                       }];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint targetPoint = CGPointMake(0, CGRectGetMinY(textField.frame) - 10);
    targetPoint.y = fminf(targetPoint.y, 74);
    [self setContentOffset:targetPoint animated:YES];
}

@end