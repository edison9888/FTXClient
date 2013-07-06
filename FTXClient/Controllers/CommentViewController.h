//
//  CommentViewController.h
//  FTXClient
//
//  Created by Lei Perry on 7/1/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import "Article.h"

@class DetailViewController;

@interface CommentViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, assign) DetailViewController *detailViewController;

- (id)initWithArticle:(Article *)article;

@end