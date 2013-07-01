//
//  MyAccountView.h
//  FTXClient
//
//  Created by Lei Perry on 7/1/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
@class AccessAccountViewController;

@interface MyAccountView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) AccessAccountViewController *controller;

- (void)populateInterface;

@end