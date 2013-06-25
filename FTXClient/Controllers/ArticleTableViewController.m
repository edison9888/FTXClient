//
//  ArticleTableViewController.m
//  FTXClient
//
//  Created by Lei Perry on 6/25/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ArticleTableViewController.h"
#import "ArticleTableViewCell.h"
#import "UIColor+FTX.h"

#define kHeaderTag 9
#define kHeaderLabelTag 1
#define kHeaderIndicatorTag 2
#define kFooterLabelTag 3
#define kFooterIndicatorTag 4

#define kHeaderPullText @"下拉刷新"
#define kHeaderLoadingText @"加载中..."
#define kHeaderReleaseText @"释放加载最新内容"

#define kFooterPullText @"更多"
#define kFooterLoadingText @"加载中..."
#define kFooterReleaseText @"释放加载更多内容"

#define REFRESH_HEADER_HEIGHT 60

@interface ArticleTableViewController ()
{
    NSMutableArray *_articles;
    NSMutableArray *_articleIds;
    BOOL isDragging;
    BOOL isLoading;
    NSUInteger nextPageNo;
}

- (void)updateToLatest;
- (void)retrieveMore;

@end

@implementation ArticleTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _articles = [NSMutableArray array];
        _articleIds = [NSMutableArray array];
        nextPageNo = 1;
    }
    return self;
}

- (void)updateToLatest {
    isLoading = YES;
    self.tableView.tableFooterView.hidden = YES;

    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        UIView *header = [self.tableView viewWithTag:kHeaderTag];
        [(UILabel *)[header viewWithTag:kHeaderLabelTag] setText:kHeaderLoadingText];
        [(UIActivityIndicatorView *)[header viewWithTag:kHeaderIndicatorTag] startAnimating];
    }];
    
    // Refresh action!
    [self performSelector:@selector(getNextPageAction) withObject:nil afterDelay:2];
}

- (void)retrieveMore {
    
}

- (void)getNextPageAction {
    [Article retrieveArticlesWithBlock:^(NSArray *articles, NSError *error){
        isLoading = NO;
        self.tableView.tableFooterView.hidden = NO;

        // Hide the header
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.contentInset = UIEdgeInsetsZero;
        }];

        UIView *header = [self.tableView viewWithTag:kHeaderTag];
        [(UILabel *)[header viewWithTag:kHeaderLabelTag] setText:kHeaderPullText];
        [(UIActivityIndicatorView *)[header viewWithTag:kHeaderIndicatorTag] stopAnimating];
        
        if (error) {
            DLog(@"error: %@", [error localizedDescription]);
        }
        else {
            for (Article *article in articles) {
                if (![_articleIds containsObject:@(article.id)]) {
                    [_articleIds addObject:@(article.id)];
                    [_articles addObject:article];
                }
            }
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }
    }
                           forCategory:CategoryTypeAll
                                atPage:nextPageNo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // header
    UIImageView *header = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-header-bg"]];
    header.frame = CGRectMake(0, -60, 320, 60);
    header.tag = kHeaderTag;

    UILabel *headerText = [[UILabel alloc] initWithFrame:CGRectMake(47, 10, 100, 46)];
    headerText.backgroundColor = [UIColor clearColor];
    headerText.tag = kHeaderLabelTag;
    headerText.font = [UIFont systemFontOfSize:13];
    headerText.text = kHeaderPullText;
    headerText.textColor = [UIColor colorWithHex:0x707070];
    headerText.shadowColor = [UIColor colorWithWhite:1 alpha:.5];
    headerText.shadowOffset = CGSizeMake(0, .5);
    [header addSubview:headerText];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.tag = kHeaderIndicatorTag;
    indicator.center = CGPointMake(300, 30);
    [header addSubview:indicator];

    [self.tableView addSubview:header];
    
    
    // footer
    UIImageView *footer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-header-bg"]];
    
    UILabel *footerText = [[UILabel alloc] initWithFrame:CGRectMake(47, 10, 100, 47)];
    footerText.backgroundColor = [UIColor clearColor];
    footerText.tag = kFooterLabelTag;
    footerText.font = [UIFont systemFontOfSize:13];
    footerText.text = kFooterPullText;
    footerText.textColor = [UIColor colorWithHex:0x707070];
    footerText.shadowColor = [UIColor colorWithWhite:1 alpha:.5];
    footerText.shadowOffset = CGSizeMake(0, .5);
    [footer addSubview:footerText];
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.tag = kFooterIndicatorTag;
    indicator.center = CGPointMake(300, 30);
    [footer addSubview:indicator];
    self.tableView.tableFooterView = footer;

    // other config
    self.tableView.rowHeight = 249;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:.7];
    [self updateToLatest];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ArticleTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Article *article = _articles[indexPath.row];
    cell.article = article;
    return cell;
}

#pragma mark - UITableViewDataDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ArticleTableViewCell heightForCellWithArticle:_articles[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - scroll
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading)
        return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        UIView *header = [self.tableView viewWithTag:kHeaderTag];
        UILabel *headerLabel = (UILabel *)[header viewWithTag:kHeaderLabelTag];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            headerLabel.text = kHeaderReleaseText;
        }
        else {
            // User is scrolling somewhere within the header
            headerLabel.text = kHeaderPullText;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self updateToLatest];
    }
}

@end
