//
//  FavoritesTableViewController.m
//  FTXClient
//
//  Created by Lei Perry on 7/19/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "FavoritesTableViewController.h"
#import "ArticleTableViewCell.h"
#import "UIView+FTX.h"
#import "DetailViewController.h"

@interface FavoritesTableViewController ()
{
    NSMutableArray *_articles;
}
@end

@implementation FavoritesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _articles = [NSMutableArray array];
        self.tableView.backgroundView = nil;
    }
    return self;
}

- (void)dealloc {
    _controller = nil;
}

- (void)updateFavorites {
    [_articles removeAllObjects];
    NSString *path = [NSString stringWithFormat:@"/app/article/like_list?userId=%d&pageNo=1", DataMgr.currentAccount.userId];
    DLog(@"%@", path);
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
                                       [self.tableView reloadData];
                                       [[NSNotificationCenter defaultCenter] postNotificationName:kTableDataLoadedNotification object:nil];
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   }];
}

- (void)deleteFavoriteAtIndexPath:(NSIndexPath *)indexPath {
    Article *article = _articles[indexPath.row];
    [self.tableView beginUpdates];
    [_articles removeObject:article];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    CGSize size = self.tableView.contentSize;
    CGFloat h = [ArticleTableViewCell heightForCellWithArticle:article];
    size.height -= h;
    self.tableView.contentSize = size;
    [[NSNotificationCenter defaultCenter] postNotificationName:kTableDataLoadedNotification object:nil];
    DLog(@"delete %@", article.title);
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
        cell.favoritesController = self;
    }
    Article *article = _articles[indexPath.row];
    cell.article = article;
    return cell;
}

#pragma mark - UITableViewDataDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ArticleTableViewCell heightForCellWithArticle:_articles[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *vc = [[DetailViewController alloc] initWithArticle:_articles[indexPath.row] navigatable:NO];
    [self.controller.navigationController pushViewController:vc animated:YES];
}

@end
