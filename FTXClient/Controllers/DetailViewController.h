//
//  DetailViewController.h
//  FTXClient
//
//  Created by Lei Perry on 6/26/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import "Article.h"
#import "Review.h"
#import "MBProgressHUD.h"

@interface DetailViewController : UIViewController <MBProgressHUDDelegate>

@property (readonly) Article *article;
@property (nonatomic, strong) Review *addingReview;
@property BOOL animateToComments;

- (id)initWithArticle:(Article *)article navigatable:(BOOL)navigatable;
- (void)layoutViews;

@end