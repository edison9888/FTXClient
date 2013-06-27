//
//  RelevantsViewController.m
//  FTXClient
//
//  Created by Lei Perry on 6/27/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "RelevantsTableViewController.h"
#import "Relevant.h"
#import "UIColor+FTX.h"
#import "WebViewController.h"
#import "HomeViewController.h"

@interface RelevantsTableViewController ()
{
    NSArray *_relevants;
    NSString *_relevantIds;
}
@end

@implementation RelevantsTableViewController

- (id)initWithRelevantIds:(NSString *)relevantIds {
    if (self = [super init]) {
        _relevantIds = relevantIds;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor colorWithWhite:0 alpha:1];
    [Relevant retrieveRelevantsWithBlock:^(NSArray *relevants, NSError *error){
        _relevants = relevants;
        [self.tableView reloadData];
    } forIds:_relevantIds];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_relevants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = [UIColor colorWithHex:0xbbbbbb];
        
        UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-arrow-button"]];
        cell.accessoryView = accessoryView;
    }
    Relevant *relevant = _relevants[indexPath.row];
    cell.textLabel.text = relevant.title;
    return cell;
}

#pragma mark - UITableViewDataDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WebViewController *vc = [[WebViewController alloc] init];
    [[HomeViewController sharedHome].navigationController pushViewController:vc animated:YES];
}

@end