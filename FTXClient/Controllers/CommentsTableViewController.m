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

@interface CommentsTableViewController ()
{
    NSArray *_reviews;
    NSUInteger _authorId, _articleId;
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
        _reviews = reviews;
        [self.tableView reloadData];
    } withAuthodId:_authorId andArticleId:_articleId];
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

#pragma mark - UITableViewDataDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CommentTableViewCell heightForCellWithReview:_reviews[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end