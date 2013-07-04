//
//  CommentViewController.h
//  FTXClient
//
//  Created by Lei Perry on 7/1/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import "Article.h"

@interface CommentViewController : UIViewController <UITextViewDelegate>

- (id)initWithArticle:(Article *)article;

@end