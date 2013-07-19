//
//  HomeViewController.h
//  FTXClient
//
//  Created by Lei Perry on 6/21/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import "ArticlesViewController.h"

@interface HomeViewController : UIViewController <UIScrollViewDelegate>

@property (readonly) ArticlesViewController *articlesCollection;
@property (readonly) NSArray *articles;
@property (readwrite) NSUInteger selectedDetailArticleIndex;

+ (HomeViewController *)sharedHome;

@end