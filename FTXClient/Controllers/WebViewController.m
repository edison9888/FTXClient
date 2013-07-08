//
//  WebViewController.m
//  FTXClient
//
//  Created by Lei Perry on 6/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WebViewController.h"

@interface WebViewController ()
{
    UIWebView *webView;
    NSString *_url;
    WebContentType contentType;
}
@end

@implementation WebViewController

- (id)initWithUrl:(NSString *)url {
    if (self = [super init]) {
        _url = url;
        contentType = WebContentTypeRelevant;
    }
    return self;
}

- (void)loadView {
    webView = [[UIWebView alloc] init];
    self.view = webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (contentType == WebContentTypeRelevant)
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    else {
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
        NSString *htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [webView loadHTMLString:htmlString baseURL:nil];
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
    self.title = contentType==WebContentTypeAbout ? @"关于我们" : @"相关新闻";
}

- (void)tapLeftBarButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapRightBarButton {
    AccessAccountViewController *vc = [[AccessAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end