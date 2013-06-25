//
//  HomeViewController.h
//  FTXClient
//
//  Created by Lei Perry on 6/21/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import "ArticleTableViewController.h"

@interface HomeViewController : UIViewController

@property (readonly) ArticleTableViewController *tableViewController;

+ (HomeViewController *)sharedHome;

@end