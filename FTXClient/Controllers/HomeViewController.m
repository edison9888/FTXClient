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
    
    CategoryPickerView *categoryPicker = [[CategoryPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [self.view addSubview:categoryPicker];
    
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    rect.origin.y = CGRectGetHeight(categoryPicker.frame);
    rect.size.height -= CGRectGetHeight(categoryPicker.frame);
    
//    _tableViewController = [[ArticleTableViewController alloc] initWithStyle:UITableViewStylePlain];
//    _tableViewController.tableView.frame = rect;
//    [self.view addSubview:_tableViewController.tableView];
    
    _articlesCollection = [[ArticlesViewController alloc] init];
    _articlesCollection.view.frame = rect;
    [self.view addSubview:_articlesCollection.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [rightButton addTarget:self action:@selector(tapRightBarButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightView = [[UIView alloc] initWithFrame:buttonRect];
    rightView.backgroundColor = [UIColor colorWithWhite:1 alpha:.12];
    rightView.layer.cornerRadius = 5;
    [rightView addSubview:rightButton];
    rightButton.center = CGPointMake(CGRectGetWidth(buttonRect)/2, CGRectGetHeight(buttonRect)/2);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    // title
    self.title = @"饭特稀体育";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfileStatus) name:kAccountChangeNotification object:[DataManager sharedManager]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCategoryType) name:kCategoryChangeNotification object:[DataManager sharedManager]];

    [self updateProfileStatus];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAccountChangeNotification object:[DataManager sharedManager]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCategoryChangeNotification object:[DataManager sharedManager]];
}

- (void)tapLeftBarButton {
    SettingViewController *sv = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:sv animated:YES];
}

- (void)tapRightBarButton {
    AccessAccountViewController *vc = [[AccessAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateProfileStatus {
    UIView *view = self.navigationItem.rightBarButtonItem.customView;
    UIButton *button = (UIButton *)view.subviews[0];
    if ([[DataManager sharedManager].currentAccount success])
        [button setImage:[UIImage imageNamed:@"icon-profile-online"] forState:UIControlStateNormal];
    else
        [button setImage:[UIImage imageNamed:@"icon-profile"] forState:UIControlStateNormal];
}

- (void)changeCategoryType {
    _articlesCollection.currentPageNo = 1;
    [_articlesCollection refreshView:YES];
}

@end