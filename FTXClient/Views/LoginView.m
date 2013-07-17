//
//  LoginView.m
//  FTXClient
//
//  Created by Lei Perry on 6/23/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "LoginView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+FTX.h"
#import "UIColor+FTX.h"
#import "UMSocial.h"
#import "HomeViewController.h"
#import "NetWorkReachability.h"
#import "Account.h"

@interface LoginView ()
{
    UITextField *mailField, *passField;
}

@end

@implementation LoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.contentSize = frame.size;
        
        mailField = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, 260, 44)];
        mailField.keyboardAppearance = UIKeyboardAppearanceAlert;
        mailField.keyboardType = UIKeyboardTypeEmailAddress;
        mailField.placeholder = @"注册邮箱@";
        mailField.textAlignment = UITextAlignmentCenter;
        mailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        mailField.layer.backgroundColor = [UIColor whiteColor].CGColor;
        mailField.layer.cornerRadius = 4;
        [self addSubview:mailField];
        
        passField = [[UITextField alloc] initWithFrame:CGRectMake(30, 84, 260, 44)];
        passField.keyboardAppearance = UIKeyboardAppearanceAlert;
        passField.placeholder = @"密码";
        passField.secureTextEntry = YES;
        passField.textAlignment = UITextAlignmentCenter;
        passField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        passField.layer.backgroundColor = [UIColor whiteColor].CGColor;
        passField.layer.cornerRadius = 4;
        [self addSubview:passField];
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(30, 138, 125, 44);
        loginButton.clipsToBounds = YES;
        loginButton.layer.cornerRadius = 4;
        [loginButton setBackgroundImage:[[UIImage imageNamed:@"button-gray-bg"] stretchableImageWithLeftCapWidth:2 topCapHeight:0] forState:UIControlStateNormal];
        [loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loginButton];
        
        UIButton *goRegisterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        goRegisterButton.frame = CGRectMake(165, 138, 125, 44);
        goRegisterButton.layer.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"button-gray-bg"] imageTintedWithColor:[UIColor colorWithHex:0xd24b00]]].CGColor;
        goRegisterButton.layer.cornerRadius = 4;
        goRegisterButton.clipsToBounds = YES;
        [goRegisterButton setBackgroundImage:[[[UIImage imageNamed:@"button-gray-bg"] imageTintedWithColor:[UIColor colorWithHex:0xd24b00]] stretchableImageWithLeftCapWidth:2 topCapHeight:0] forState:UIControlStateNormal];
        [goRegisterButton setTitle:@"注册" forState:UIControlStateNormal];
        [goRegisterButton setTitleColor:[UIColor colorWithHex:0xcccccc] forState:UIControlStateNormal];
        [goRegisterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [goRegisterButton addTarget:self action:@selector(gotoRegister) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:goRegisterButton];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 192, 130, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"使用以下方式登录：";
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        
        UIButton *btnWeibo = [UIButton buttonWithType:UIButtonTypeCustom];
        btnWeibo.frame = CGRectMake(160, 192, 44, 44);
        btnWeibo.tag = UMSocialSnsTypeSina;
        [btnWeibo setImage:[UIImage imageNamed:@"login-way-weibo"] forState:UIControlStateNormal];
        [btnWeibo addTarget:self action:@selector(loginViaSns:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnWeibo];

        UIButton *btnQQ = [UIButton buttonWithType:UIButtonTypeCustom];
        btnQQ.frame = CGRectMake(204, 192, 44, 44);
        btnQQ.tag = UMSocialSnsTypeQzone;
        [btnQQ setImage:[UIImage imageNamed:@"login-way-qq"] forState:UIControlStateNormal];
        [btnQQ addTarget:self action:@selector(loginViaSns:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnQQ];
    }
    return self;
}

- (void)gotoRegister {
    [_controller switchToView:AccountViewTypeRegister];
}

- (void)loginViaSns:(UIButton *)button {
    NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:button.tag];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
    snsPlatform.loginClickHandler([HomeViewController sharedHome], [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response){
        
        //如果是授权到新浪微博，SSO之后如果想获取用户的昵称、头像等需要再次获取一次账户信息
        if ([platformName isEqualToString:UMShareToSina]) {
            [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse){
                NSDictionary *dict = [[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToSina];
                DLog(@"sina: %@", accountResponse.data);
                [DataMgr loginVia:LoginTypeSina
                                        withAccountId:dict[@"usid"]
                                          andPassword:@""
                                          andNickName:dict[@"username"]
                                    popViewController:[HomeViewController sharedHome]];
            }];
        }
        
        if ([platformName isEqualToString:UMShareToQzone]) {
            NSDictionary *dict = [response.data objectForKey:UMShareToQzone];
            if (dict) {
                [DataMgr loginVia:LoginTypeTencent
                                        withAccountId:dict[@"usid"]
                                          andPassword:@""
                                          andNickName:dict[@"username"]
                                    popViewController:[HomeViewController sharedHome]];
            }
        }
    });
}

- (void)loginAction {
    // check mail address
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    if ([emailTest evaluateWithObject:mailField.text] == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入正确的邮箱地址" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [mailField becomeFirstResponder];
        return;
    }
    
    // check password
    if ([passField.text length] < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"密码长度不能少于6位" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [passField becomeFirstResponder];
        return;
    }
    
    [DataMgr loginVia:LoginTypeFtx
                            withAccountId:mailField.text
                              andPassword:passField.text
                              andNickName:@""
                        popViewController:[HomeViewController sharedHome]];
}

@end