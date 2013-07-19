//
//  FavoritesTableViewController.h
//  FTXClient
//
//  Created by Lei Perry on 7/19/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import "Article.h"

@interface FavoritesTableViewController : UITableViewController

@property (nonatomic, assign) UIViewController *controller;

- (void)updateFavorites;
- (void)deleteFavoriteAtIndexPath:(NSIndexPath *)indexPath;

@end