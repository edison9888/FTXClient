//
//  SettingViewController.h
//  FTXClient
//
//  Created by huang xiang on 7/5/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    UITableView *tableView;
    NSArray *btnNames;
}

@end
