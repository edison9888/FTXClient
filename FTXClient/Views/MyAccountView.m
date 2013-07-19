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
}

@end

@implementation MyAccountView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
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
        _favoritesTable = [[FavoritesTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _favoritesTable.tableView.frame = CGRectMake(0, 135, 320, CGRectGetHeight(rect) - 44 - 145);
        _favoritesTable.tableView.hidden = YES;
        [self addSubview:_favoritesTable.view];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favoritesDataLoaded) name:kTableDataLoadedNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTableDataLoadedNotification object:nil];
    _controller = nil;
}

- (void)favoritesDataLoaded {
    CGSize size = self.frame.size;
    CGRect rect = _favoritesTable.view.frame;
    rect.size.height = _favoritesTable.tableView.contentSize.height;
    _favoritesTable.tableView.hidden = NO;
    _favoritesTable.view.frame = rect;
    if (CGRectGetMinY(_favoritesTable.view.frame) + _favoritesTable.tableView.contentSize.height > size.height)
        size.height = CGRectGetMinY(_favoritesTable.view.frame) + _favoritesTable.tableView.contentSize.height;
    self.contentSize = size;
}

- (void)populateInterface {
    if (DataMgr.currentAccount) {
        [_avatarView setImageWithURL:[NSURL URLWithString:DataMgr.currentAccount.avatarUrl] placeholderImage:[UIImage imageNamed:@"avatar-placeholder"]];
        _nameLabel.text = DataMgr.currentAccount.nickName;
        [_favoritesTable updateFavorites];
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

@end