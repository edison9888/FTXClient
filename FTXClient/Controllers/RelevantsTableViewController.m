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
#import "DetailViewController.h"

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
        if ([self.controller respondsToSelector:@selector(layoutViews)])
            [self.controller layoutViews];
    } forIds:_relevantIds];
}

- (CGFloat)cellHeightForRelevant:(Relevant *)relevant {
    CGFloat h = 30;
    CGSize size = [relevant.title sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(260, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return h + size.height;
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
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = [UIColor colorWithHex:0xdddddd];
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.detailTextLabel.textColor = [UIColor colorWithHex:0x999999];
        
        UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-arrow-button"]];
        cell.accessoryView = accessoryView;
    }
    Relevant *relevant = _relevants[indexPath.row];
    cell.textLabel.text = relevant.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"来自%@", relevant.sourceTypeName];
    return cell;
}

#pragma mark - UITableViewDataDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Relevant *relevent = _relevants[indexPath.row];
    return [self cellHeightForRelevant:relevent];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Relevant *relevant = _relevants[indexPath.row];
    WebViewController *vc = [[WebViewController alloc] initWithRelevant:relevant];
    [[HomeViewController sharedHome].navigationController pushViewController:vc animated:YES];
}

@end