//
//  CommentsViewController.m
//  FTXClient
//
//  Created by Lei Perry on 6/27/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "CommentsTableViewController.h"
#import "CommentTableViewCell.h"
#import "Review.h"
#import "DetailViewController.h"

@interface CommentsTableViewController ()
{
    NSUInteger _authorId, _articleId;
    NSIndexPath *_deletingIndexPath;
}
@end

@implementation CommentsTableViewController

- (id)initWithAuthorId:(NSUInteger)authorId andArticleId:(NSUInteger)articleId {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _authorId = authorId;
        _articleId = articleId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor colorWithWhite:0 alpha:1];
    [Review retrieveReviewsWithBlock:^(NSArray *reviews, NSError *error){
        _reviews = [reviews mutableCopy];
        [self.tableView reloadData];
        [self.controller layoutViews];
    } withAuthodId:_authorId andArticleId:_articleId];
}

- (void)deleteReview:(Review *)review {
    NSString *path = [NSString stringWithFormat:@"/app/article/del_review?userId=%d&pwd=%@&authorId=%d&articleId=%d&reviewId=%d", DataMgr.currentAccount.userId, DataMgr.currentAccount.password, review.author.id, review.articleId, review.id];
    DLog(@"path=%@", path);
    [[AFFTXAPIClient sharedClient] getPath:path
                                parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id JSON) {
                                       DLog(@"delete review: %@", JSON);
                                       if ([JSON[@"success"] boolValue]) {
                                           [self.tableView beginUpdates];
                                           [_reviews removeObject:review];
                                           [self.tableView deleteRowsAtIndexPaths:@[_deletingIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                                           [self.tableView endUpdates];
                                       }
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       DLog(@"error: %@", error.description);
                                   }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_reviews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Review *review = _reviews[indexPath.row];
    cell.review = review;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    Review *review = _reviews[indexPath.row];
    return review.reviewer.id == DataMgr.currentAccount.userId;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _deletingIndexPath = indexPath;
        Review *review = _reviews[indexPath.row];
        [self deleteReview:review];
    }
}

#pragma mark - UITableViewDataDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Review *review = _reviews[indexPath.row];
    return [CommentTableViewCell heightForCellWithReview:review];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end