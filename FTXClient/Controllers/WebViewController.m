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
    Relevant *_relevant;
    NSString *_url;
    WebContentType contentType;
}
@end

@implementation WebViewController

- (id)initWithUrl:(NSString *)url {
    if (self = [super init]) {
        _url = url;
        contentType = WebContentTypeUrl;
    }
    return self;
}

- (id)initWithRelevant:(Relevant *)relevant {
    if (self = [super init]) {
        _relevant = relevant;
        contentType = WebContentTypeRelevant;
    }
    return self;
}

- (void)loadView {
    webView = [[UIWebView alloc] init];
    webView.delegate = self;
    self.view = webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    switch (contentType) {
        case WebContentTypeUrl:
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
            break;
        case WebContentTypeRelevant:
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_relevant.sourceUrl]]];
            break;
        case WebContentTypeAbout: {
            NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
            NSString *htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
            [webView loadHTMLString:htmlString baseURL:nil];
        }
            break;
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *title;
    switch (contentType) {
        case WebContentTypeRelevant:
            title = _relevant.title;
            break;
        case WebContentTypeAbout:
            title = @"关于我们";
            break;
        default:
            title = self.title;
            break;
    }
    CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:20]];
    if (size.width > 266) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 266, 44)];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = title;
        self.navigationItem.titleView = titleLabel;
    }
    else {
        self.title = title;
    }
}

- (void)tapLeftBarButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapRightBarButton {
    AccessAccountViewController *vc = [[AccessAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
    if (self.contentFits && [theWebView respondsToSelector:@selector(scrollView)]) {
        CGSize contentSize = theWebView.scrollView.contentSize;
        CGSize viewSize = self.view.bounds.size;
        
        float rw = viewSize.width / contentSize.width;
        
        theWebView.scrollView.minimumZoomScale = rw;
        theWebView.scrollView.maximumZoomScale = rw;
        theWebView.scrollView.zoomScale = rw;
    }
}

@end