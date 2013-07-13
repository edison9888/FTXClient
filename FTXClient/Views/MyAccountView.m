//
//  MyAccountView.m
//  FTXClient
//
//  Created by Lei Perry on 7/1/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MyAccountView.h"
#import "UIColor+FTX.h"
#import "UIImage+FTX.h"
#import "UIImageView+AFNetworking.h"
#import "Article.h"
#import "DetailViewController.h"
#import "HomeViewController.h"

@interface MyAccountView ()
{
    UIImageView *_avatarView;
    UILabel *_nameLabel;
    NSMutableArray *_articles;
}

@end

@implementation MyAccountView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _articles = [NSMutableArray array];
        
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 70, 70)];
        [self addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, 200, 24)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor colorWithHex:0xdddddd];
        [self addSubview:_nameLabel];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(250, 20, 60, 24);
        button.layer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button-gray-bg"]].CGColor;
        button.layer.cornerRadius = 4;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 115, 320, 1)];
        line.backgroundColor = [UIColor colorWithHex:0xbbbbbb];
        [self addSubview:line];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 70, 30)];
        label.backgroundColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"我喜欢的";
        label.textColor = [UIColor colorWithHex:0xbbbbbb];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        CGRect rect = [UIScreen mainScreen].applicationFrame;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 135, 300, CGRectGetHeight(rect) - 44 - 145)];
        _tableView.backgroundColor = [UIColor colorWithHex:0x444444];
        _tableView.separatorColor = [UIColor blackColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
    }
    return self;
}

- (void)populateInterface {
    if (DataMgr.currentAccount) {
        [_avatarView setImageWithURL:[NSURL URLWithString:DataMgr.currentAccount.avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar-placeholder"]];
        _nameLabel.text = DataMgr.currentAccount.nickName;
        
        [_articles removeAllObjects];
        NSString *path = [NSString stringWithFormat:@"/app/article/like_list?userId=%d&pageNo=1", DataMgr.currentAccount.userId];
        [[AFFTXAPIClient sharedClient] getPath:path
                                    parameters:nil
                                       success:^(AFHTTPRequestOperation *operation, id JSON) {
                                           NSArray *postsFromResponse = [JSON valueForKeyPath:@"articles"];
                                           for (NSDictionary *attributes in postsFromResponse) {
                                               @autoreleasepool {
                                                   Article *article = [[Article alloc] initWithAttributes:attributes];
                                                   [_articles addObject:article];
                                               }
                                           }
                                           [_tableView reloadData];
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       }];
    }
}

- (void)logout {
    [UserDefaults setValue:@"" forKey:kUCLoginAccountId];
    [UserDefaults setValue:@"" forKey:kUCLoginPassword];
    [UserDefaults setInteger:LoginTypeNotLoggedIn forKey:kUCLoginType];
    [UserDefaults synchronize];
    
    DataMgr.currentAccount = nil;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"已退出" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [self.controller.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = [UIColor colorWithHex:0xbbbbbb];
        
        UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-arrow-button"]];
        cell.accessoryView = accessoryView;
    }
    Article *article = _articles[indexPath.row];
    cell.textLabel.text = !isEmpty(article.title) ? article.title : article.summary;
    return cell;
}

#pragma mark - UITableViewDataDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Article *article = _articles[indexPath.row];
    DetailViewController *vc = [[DetailViewController alloc] initWithArticle:article];
    [self.controller.navigationController pushViewController:vc animated:YES];
}

@end