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

#define kAgreeButtonTag 1

@implementation RegisterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        UITextField *mailField = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, 260, 44)];
        mailField.placeholder = @"常用邮箱@";
        mailField.textAlignment = UITextAlignmentCenter;
        mailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        mailField.layer.backgroundColor = [UIColor whiteColor].CGColor;
        mailField.layer.cornerRadius = 4;
        [self addSubview:mailField];

        UITextField *userField = [[UITextField alloc] initWithFrame:CGRectMake(30, 84, 260, 44)];
        userField.placeholder = @"密码";
        userField.textAlignment = UITextAlignmentCenter;
        userField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        userField.layer.backgroundColor = [UIColor whiteColor].CGColor;
        userField.layer.cornerRadius = 4;
        [self addSubview:userField];

        UITextField *passField = [[UITextField alloc] initWithFrame:CGRectMake(30, 138, 260, 44)];
        passField.placeholder = @"密码";
        passField.secureTextEntry = YES;
        passField.textAlignment = UITextAlignmentCenter;
        passField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        passField.layer.backgroundColor = [UIColor whiteColor].CGColor;
        passField.layer.cornerRadius = 4;
        [self addSubview:passField];
        
        CustomIconButton *agreeButton = [CustomIconButton buttonWithType:UIButtonTypeCustom];
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
        [regButton addTarget:_controller action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:regButton];
        
        UIButton *goLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        goLoginButton.frame = CGRectMake(165, 226, 125, 44);
        goLoginButton.layer.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"button-gray-bg"] imageTintedWithColor:[UIColor colorWithHex:0xd24b00]]].CGColor;
        goLoginButton.layer.cornerRadius = 4;
        [goLoginButton setTitle:@"登录" forState:UIControlStateNormal];
        [goLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [goLoginButton addTarget:_controller action:@selector(switchLoginAndRegister) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:goLoginButton];
    }
    return self;
}

- (void)toggleAgreeButton:(UIButton *)button {
    button.selected = !button.selected;
}

@end