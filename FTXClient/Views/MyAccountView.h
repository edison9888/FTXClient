//
//  MyAccountView.h
//  FTXClient
//
//  Created by Lei Perry on 7/1/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "FavoritesTableViewController.h"

@class AccessAccountViewController;

@interface MyAccountView : UIScrollView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) AccessAccountViewController *controller;
@property (nonatomic, strong) FavoritesTableViewController *favoritesTable;

- (void)populateInterface;

@end