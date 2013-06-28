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
#import "AccessAccountViewController.h"
#import "UMSocial.h"
#import "HomeViewController.h"

@implementation LoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        UITextField *userField = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, 260, 44)];
        userField.placeholder = @"用户名";
        userField.textAlignment = UITextAlignmentCenter;
        userField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        userField.layer.backgroundColor = [UIColor whiteColor].CGColor;
        userField.layer.cornerRadius = 4;
        [self addSubview:userField];
        
        UITextField *passField = [[UITextField alloc] initWithFrame:CGRectMake(30, 84, 260, 44)];
        passField.placeholder = @"密码";
        passField.secureTextEntry = YES;
        passField.textAlignment = UITextAlignmentCenter;
        passField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        passField.layer.backgroundColor = [UIColor whiteColor].CGColor;
        passField.layer.cornerRadius = 4;
        [self addSubview:passField];
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(30, 138, 125, 44);
        loginButton.layer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button-gray-bg"]].CGColor;
        loginButton.layer.cornerRadius = 4;
        [loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [loginButton addTarget:_controller action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loginButton];
        
        UIButton *goRegisterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        goRegisterButton.frame = CGRectMake(165, 138, 125, 44);
        goRegisterButton.layer.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"button-gray-bg"] imageTintedWithColor:[UIColor colorWithHex:0xd24b00]]].CGColor;
        goRegisterButton.layer.cornerRadius = 4;
        [goRegisterButton setTitle:@"注册" forState:UIControlStateNormal];
        [goRegisterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [goRegisterButton addTarget:_controller action:@selector(switchLoginAndRegister) forControlEvents:UIControlEventTouchUpInside];
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

- (void)loginViaSns:(UIButton *)button {
    NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:button.tag];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
    snsPlatform.loginClickHandler([HomeViewController sharedHome], [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response){
        
        //如果是授权到新浪微博，SSO之后如果想获取用户的昵称、头像等需要再次获取一次账户信息
        if ([platformName isEqualToString:UMShareToSina]) {
            [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse){
                DLog(@"SinaWeibo's user name is %@", [[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToSina] objectForKey:@"username"]);
            }];
        }
    });
}

@end