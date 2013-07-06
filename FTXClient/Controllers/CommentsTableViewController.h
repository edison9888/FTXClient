//
//  CommentsViewController.h
//  FTXClient
//
//  Created by Lei Perry on 6/27/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

@class DetailViewController;

@interface CommentsTableViewController : UITableViewController

@property (nonatomic, assign) DetailViewController *controller;

- (id)initWithAuthorId:(NSUInteger)authorId andArticleId:(NSUInteger)articleId;

@end