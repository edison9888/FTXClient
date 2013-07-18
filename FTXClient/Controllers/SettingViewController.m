//
//  SettingViewController.m
//  FTXClient
//
//  Created by huang xiang on 7/5/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import <objc/message.h>
#import "SettingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+FTX.h"
#import "UIImage+FTX.h"
#import "WebViewController.h"
#import "MobClick.h"
#import "UMFeedback.h"

#define kAlertCleanCacheTag 1
#define kAlertUpdateTag 2

@interface SettingViewController ()
{
    UITableView *_tableView;
    UIImageView *_accessoryView;
    NSArray *_names;
}
@end

@implementation SettingViewController

- (id)init {
    if (self = [super init]) {
        _names = @[@"清空图片缓存", @"检查版本", @"意见反馈", @"关于我们"];
        _accessoryView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cell-arrow-button"] imageTintedWithColor:[UIColor colorWithHex:0x666666]]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, 320) style:UITableViewStyleGrouped];
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor colorWithHex:0x000000];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];

    [_tableView reloadData];
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
    self.title  = @"设置";    
}

- (void)tapLeftBarButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (alertView.tag == kAlertCleanCacheTag && buttonIndex == 1) {
        NSString *docDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *imagesFolder = [docDirectory stringByAppendingPathComponent:@"images"];
        BOOL b = [[NSFileManager defaultManager] removeItemAtPath:imagesFolder error:nil];
        if (b) {
            [[NSFileManager defaultManager] createDirectoryAtPath:imagesFolder
                                      withIntermediateDirectories:NO
                                                       attributes:nil
                                                            error:nil];
        }
        else {
            DLog(@"clean cache failed");
        }
    }
    if (alertView.tag == kAlertUpdateTag && buttonIndex == 1) {
        NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kAppStoreId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

- (void)action0 {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:_names[0]
                                                        message:@"确定要清空所有图片缓存吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"否"
                                              otherButtonTitles:@"是",
                              nil];
    alertView.tag = kAlertCleanCacheTag;
	[alertView show];
}

- (void)action1 {
    [MobClick checkUpdateWithDelegate:self selector:@selector(appUpdate:)];
}

- (void)action2 {
    [UMFeedback showFeedback:self withAppkey:kUMengAppKey];
}

- (void)action3 {
    WebViewController *vc = [[WebViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)appUpdate:(NSDictionary *)appInfo {
    if ([appInfo[@"update"] boolValue]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"发些新版本，你希望现在更新吗？"
                                                           delegate:self
                                                  cancelButtonTitle:@"否"
                                                  otherButtonTitles:@"是",
                                  nil];
        alertView.tag = kAlertUpdateTag;
        [alertView show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"你正在使用的是最新版本！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_names count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.textLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    cell.textLabel.text = _names[indexPath.row];
    cell.accessoryView = indexPath.row + 1== [_names count] ? _accessoryView : nil;
    return cell;
}

#pragma mark - UITableViewDataDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"action%d", indexPath.row]);
    if ([self respondsToSelector:selector]) {
        objc_msgSend(self, selector);
    }
}

@end