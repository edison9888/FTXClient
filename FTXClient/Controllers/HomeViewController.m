//
//  HomeViewController.m
//  FTXClient
//
//  Created by Lei Perry on 6/21/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
#import "UIColor+FTX.h"
#import "CategoryPickerView.h"
#import "SettingViewController.h"

@interface HomeViewController ()
{
    CategoryPickerView *_categoryPicker;
    UIScrollView *_scrollView;
    CGPoint _targetOffset;
}
@end

@implementation HomeViewController

+ (HomeViewController *)sharedHome {
    static HomeViewController *_sharedHome = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHome = [[HomeViewController alloc] init];
    });
    return _sharedHome;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
    
    _categoryPicker = [[CategoryPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [self.view addSubview:_categoryPicker];
    
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    rect.origin.y = CGRectGetHeight(_categoryPicker.frame);
    rect.size.height -= CGRectGetHeight(_categoryPicker.frame) + 44;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:rect];
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(rect) * 5, CGRectGetHeight(rect));
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    _articlesCollection = [[ArticlesViewController alloc] init];
    _articlesCollection.view.frame = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect));
    [_scrollView addSubview:_articlesCollection.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _targetOffset = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect buttonRect = CGRectMake(0, 0, 44, 44);
    buttonRect = CGRectInset(buttonRect, 4, 4);
    
    // left bar button
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton setImage:[UIImage imageNamed:@"icon-settings"] forState:UIControlStateNormal];
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
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [titleButton setTitle:@"饭特稀体育" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [titleButton addTarget:self action:@selector(tapTitle) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfileStatus) name:kAccountChangeNotification object:DataMgr];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCategoryIndex) name:kCategoryIndexChangeNotification object:DataMgr];
    
    // update profile icon status
    UIView *view = self.navigationItem.rightBarButtonItem.customView;
    UIButton *button = (UIButton *)view.subviews[0];
    if ([DataMgr.currentAccount success])
        [button setImage:[UIImage imageNamed:@"icon-profile-online"] forState:UIControlStateNormal];
    else
        [button setImage:[UIImage imageNamed:@"icon-profile"] forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAccountChangeNotification object:DataMgr];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCategoryIndexChangeNotification object:DataMgr];
}

- (void)tapTitle {
    _categoryPicker.selectedIndex = 0;
}

- (void)tapLeftBarButton {
    SettingViewController *vc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapRightBarButton {
    AccessAccountViewController *vc = [[AccessAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateProfileStatus {
    UIView *view = self.navigationItem.rightBarButtonItem.customView;
    UIButton *button = (UIButton *)view.subviews[0];
    if ([DataMgr.currentAccount success])
        [button setImage:[UIImage imageNamed:@"icon-profile-online"] forState:UIControlStateNormal];
    else
        [button setImage:[UIImage imageNamed:@"icon-profile"] forState:UIControlStateNormal];
    
    [_articlesCollection refreshView:NO];
}

- (void)changeCategoryIndex {
    _articlesCollection.currentPageNo = 1;
    if (_scrollView.contentOffset.x != 320 * DataMgr.categoryIndex) {
        _targetOffset = CGPointMake(320 * DataMgr.categoryIndex, 0);
        [_scrollView setContentOffset:_targetOffset animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGPoint maxPoint = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
    if (CGPointEqualToPoint(_targetOffset, maxPoint) || CGPointEqualToPoint(_targetOffset, _scrollView.contentOffset)) {
        int pageIndex = floor((_scrollView.contentOffset.x - 160) / 320) + 1;
        if (pageIndex == DataMgr.categoryIndex && CGPointEqualToPoint(_targetOffset, maxPoint))
            return;
        
        _categoryPicker.selectedIndex = pageIndex;
        CGRect rect = _articlesCollection.view.frame;
        _articlesCollection.view.frame = CGRectMake(pageIndex * 320, 0, 320, CGRectGetHeight(rect));
        DataMgr.categoryIndex = pageIndex;
        [_articlesCollection refreshView:YES];
        
        if (CGPointEqualToPoint(_targetOffset, _scrollView.contentOffset))
            _targetOffset = maxPoint;
    }
}

@end