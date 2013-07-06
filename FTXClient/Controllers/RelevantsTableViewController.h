//
//  RelevantsViewController.h
//  FTXClient
//
//  Created by Lei Perry on 6/27/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import "DetailViewController.h"

@interface RelevantsTableViewController : UITableViewController

@property (nonatomic, assign) DetailViewController *controller;

- (id)initWithRelevantIds:(NSString *)relevantIds;

@end