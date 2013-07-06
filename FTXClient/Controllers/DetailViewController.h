//
//  DetailViewController.h
//  FTXClient
//
//  Created by Lei Perry on 6/26/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import "Article.h"

@interface DetailViewController : UIViewController

@property (readonly) Article *article;
@property BOOL animateToComments;

- (id)initWithArticle:(Article *)article;

@end