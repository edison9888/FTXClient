//
//  DetailViewController.m
//  FTXClient
//
//  Created by Lei Perry on 6/26/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import "AccessAccountViewController.h"
#import "CustomIconButton.h"
#import "UIColor+FTX.h"

@interface DetailViewController ()
{
    UIImageView *_avatarView, *_imageView;
    UILabel *_authorNameLabel, *_publishLabel;
    UILabel *_titleLabel, *_contentLabel;
    CustomIconButton *_likeButton, *_commentButton, *_shareButton;
}
@end

@implementation DetailViewController

- (id)initWithArticle:(Article *)article {
    if (self = [super init]) {
        _article = article;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-cell-bg"]];
    [self.view addSubview:bgImageView];
    
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    rect = CGRectMake(10, 0, 300, CGRectGetHeight(rect)-44-28);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rect];
    [self.view addSubview:scrollView];
    
    _likeButton = [CustomIconButton buttonWithType:UIButtonTypeCustom];
    _likeButton.imageOriginX = 8;
    _likeButton.titleOriginX = 32;
    _likeButton.backgroundColor = [UIColor colorWithHex:0xff5f3e];
    _likeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _likeButton.frame = CGRectMake(10, CGRectGetHeight(rect), 66, 28);
    [_likeButton addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];
    [_likeButton setImage:[UIImage imageNamed:@"cell-icon-heart"] forState:UIControlStateNormal];
    [self.view addSubview:_likeButton];
    
    _commentButton = [CustomIconButton buttonWithType:UIButtonTypeCustom];
    _commentButton.imageOriginX = 8;
    _commentButton.titleOriginX = 32;
    _commentButton.backgroundColor = [UIColor colorWithHex:0x0091cb];
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _commentButton.frame = CGRectMake(76, CGRectGetHeight(rect), 66, 28);
    [_commentButton addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [_commentButton setImage:[UIImage imageNamed:@"cell-icon-bubble"] forState:UIControlStateNormal];
    [self.view addSubview:_commentButton];
    
    _shareButton = [CustomIconButton buttonWithType:UIButtonTypeCustom];
    _shareButton.imageOriginX = 5;
    _shareButton.titleOriginX = 26;
    _shareButton.backgroundColor = [UIColor colorWithHex:0x007740];
    _shareButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _shareButton.frame = CGRectMake(253, CGRectGetHeight(rect), 57, 28);
    [_shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [_shareButton setImage:[UIImage imageNamed:@"cell-icon-share"] forState:UIControlStateNormal];
    [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [self.view addSubview:_shareButton];
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
    
    
    // right bar button
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setImage:[UIImage imageNamed:@"icon-profile"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(tapRightBarButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightView = [[UIView alloc] initWithFrame:buttonRect];
    rightView.backgroundColor = [UIColor colorWithWhite:1 alpha:.12];
    rightView.layer.cornerRadius = 5;
    [rightView addSubview:rightButton];
    rightButton.center = CGPointMake(CGRectGetWidth(buttonRect)/2, CGRectGetHeight(buttonRect)/2);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    // title
    self.title = @"饭特稀体育";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self layoutViews];
}

- (void)layoutViews {
    
}

- (void)tapLeftBarButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapRightBarButton {
    AccessAccountViewController *vc = [[AccessAccountViewController alloc] initWithLogin:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - actions
- (void)likeAction {
    DLog(@"like");
}

- (void)commentAction {
    DLog(@"comment");
}

- (void)shareAction {
    DLog(@"share");
}


@end