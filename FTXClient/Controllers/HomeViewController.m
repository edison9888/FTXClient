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
#import "AccessAccountViewController.h"
#import "ArticleTableViewCell.h"

#define kFooterLabelTag 1
#define kFooterIndicatorTag 2

@interface HomeViewController ()
{
    NSArray *_articles;
}
@end

@implementation HomeViewController

+ (HomeViewController *)sharedHome {
    static HomeViewController *_sharedHome = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHome = [[HomeViewController alloc] init];
        _sharedHome.cellHeights = [NSMutableDictionary dictionary];
    });
    return _sharedHome;
}

- (void)reload {
    [Article retrieveArticlesWithBlock:^(NSArray *articles, NSError *error){
        if (error) {
            DLog(@"error: %@", [error localizedDescription]);
        }
        else {
            _articles = articles;
            _tableView.hidden = NO;
            [_tableView reloadData];
        }
    }
                           forCategory:CategoryTypeAll
                                atPage:0];
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
    
    CategoryPickerView *categoryPicker = [[CategoryPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [self.view addSubview:categoryPicker];
    
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    rect.origin.y = 40;
    rect.size.height -= 40 + 44;
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor colorWithWhite:1 alpha:.7];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIImageView *header = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-header-bg"]];
    header.frame = CGRectMake(0, -60, 320, 60);
    UILabel *headerText = [[UILabel alloc] initWithFrame:CGRectMake(47, 10, 100, 46)];
    headerText.backgroundColor = [UIColor clearColor];
    headerText.tag = kFooterLabelTag;
    headerText.font = [UIFont systemFontOfSize:13];
    headerText.text = @"下拉刷新列表";
    headerText.textColor = [UIColor colorWithHex:0x707070];
    headerText.shadowColor = [UIColor colorWithWhite:1 alpha:.5];
    headerText.shadowOffset = CGSizeMake(0, .5);
    [header addSubview:headerText];
    [_tableView addSubview:header];
    
    UIImageView *footer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-header-bg"]];
    UILabel *footerText = [[UILabel alloc] initWithFrame:CGRectMake(47, 10, 100, 47)];
    footerText.backgroundColor = [UIColor clearColor];
    footerText.tag = kFooterLabelTag;
    footerText.font = [UIFont systemFontOfSize:13];
    footerText.text = @"更多 ...";
    footerText.textColor = [UIColor colorWithHex:0x707070];
    footerText.shadowColor = [UIColor colorWithWhite:1 alpha:.5];
    footerText.shadowOffset = CGSizeMake(0, .5);
    [footer addSubview:footerText];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.center = CGPointMake(300, 30);
    [footer addSubview:indicator];
    _tableView.tableFooterView = footer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.rowHeight = 249;
    _tableView.hidden = YES;
    [self reload];
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
    self.title = @"饭特稀体育";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"返回";
}

- (void)tapLeftBarButton {
    DLog(@"tap left");
}

- (void)tapRightBarButton {
    AccessAccountViewController *vc = [[AccessAccountViewController alloc] initWithLogin:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath {
    Article *article = _articles[indexPath.row];
    if (article) {
        if (isEmpty([_cellHeights objectForKey:indexPath])) {
            CGFloat h = [ArticleTableViewCell heightForCellWithArticle:article];
            [_cellHeights setObject:@(h) forKey:indexPath];
        }
        return [_cellHeights[indexPath] floatValue];
    }
    else
        return _tableView.rowHeight;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ArticleTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Article *article = _articles[indexPath.row];
    cell.article = article;
    return cell;
}

#pragma mark - UITableViewDataDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end