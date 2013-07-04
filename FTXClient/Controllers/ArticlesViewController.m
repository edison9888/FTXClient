//
//  ArticlesViewController.m
//  FTXClient
//
//  Created by Lei Perry on 7/3/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ArticlesViewController.h"
#import "UIColor+FTX.h"
#import "DetailViewController.h"
#import "HomeViewController.h"
#import "ArticleViewCell.h"

#define kHeaderTag 9
#define kFooterTag 10
#define kHeaderLabelTag 1
#define kHeaderIndicatorTag 2
#define kFooterLabelTag 3
#define kFooterIndicatorTag 4


@interface ArticlesViewController ()
{
    NSMutableArray *_articles;
    NSMutableArray *_articleIds;
    NSUInteger nextPageNo;
    
    PSCollectionView *_collectionView;
}
@end

@implementation ArticlesViewController

- (id)init {
    if (self = [super init]) {
        _articles = [NSMutableArray array];
        _articleIds = [NSMutableArray array];
        nextPageNo = 1;
        
        // retrieve from cache database
//        FMResultSet *rs = [[DataManager sharedManager].db executeQuery:@"SELECT * FROM Article"];
//        while ([rs next]) {
//            Article *article = [[Article alloc] initWithResultSet:rs];
//            [_articleIds addObject:@(article.id)];
//            [_articles addObject:article];
//        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _collectionView = [[PSCollectionView alloc] initWithFrame:self.view.bounds];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.collectionViewDataSource = self;
    _collectionView.collectionViewDelegate = self;
    _collectionView.delegate = self;
    _collectionView.numColsPortrait = 2;
    [self.view addSubview:_collectionView];
    
    [self createHeaderView];
    [self loadDataSource];
}

- (void)loadDataSource {
    NSString *path = [NSString stringWithFormat:@"/app/article/list?pageNo=%d", nextPageNo];
    [[AFFTXAPIClient sharedClient] getPath:path
                                parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id JSON) {
                                       NSArray *postsFromResponse = [JSON valueForKeyPath:@"articles"];
                                       for (NSDictionary *attributes in postsFromResponse) {
                                           @autoreleasepool {
                                               Article *article = [[Article alloc] initWithAttributes:attributes];
                                               if (![_articleIds containsObject:@(article.id)]) {
                                                   [_articleIds addObject:@(article.id)];
                                                   [_articles addObject:article];
                                               }
                                               
                                               // cache articles
                                               [[DataManager sharedManager] cacheArticle:article];
                                               
                                               // interface update
                                               [_refreshHeaderView setState:EGOOPullRefreshNormal];
                                           }
                                       }
                                       
                                       [_collectionView reloadData];
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       DLog(@"error: %@", error.description);
                                   }];
}

#pragma mark - PSCollectionViewDelegate
- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index {
    DetailViewController *vc = [[DetailViewController alloc] initWithArticle:_articles[index]];
    [[HomeViewController sharedHome].navigationController pushViewController:vc animated:YES];
}

- (Class)collectionView:(PSCollectionView *)collectionView cellClassForRowAtIndex:(NSInteger)index {
    return [PSCollectionViewCell class];
}

#pragma mark - PSCollectionViewDelegateDataSource
- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView {
    return [_articles count];
}

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index {
    ArticleViewCell *cell = (ArticleViewCell *)[collectionView dequeueReusableViewForClass:[ArticleViewCell class]];
    if (cell == nil) {
        cell = [[ArticleViewCell alloc] init];
    }
    cell.article = [_articles objectAtIndex:index];
    return cell;
}

- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index {
    CGFloat h = [ArticleViewCell rowHeightForObject:_articles[index] inColumnWidth:collectionView.colWidth];
    return h;
}

#pragma mark - methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height, self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[_collectionView addSubview:_refreshHeaderView];
}

-(void)removeHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = nil;
}

-(void)setFooterView{
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(_collectionView.contentSize.height, _collectionView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f, height, _collectionView.frame.size.width, self.view.bounds.size.height);
    }
    else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height, _collectionView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [_collectionView addSubview:_refreshFooterView];
    }
}

-(void)removeFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

// force to show the refresh headerView
-(void)showRefreshHeader:(BOOL)animated{
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		_collectionView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [_collectionView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}
	else
	{
        _collectionView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[_collectionView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
	}
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
}

#pragma mark - data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    }
    else if (aRefreshPos == EGORefreshFooter) {
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
    }
    
	// overide, the actual loading data operation is done in the subclass
}

#pragma mark - method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_collectionView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_collectionView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark - EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
	
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate *)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

-(void)refreshView{
    [self testFinishedLoadData];
}

-(void)getNextPageView{
    [self removeFooterView];
    
    [self testFinishedLoadData];
    
}

-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    [self setFooterView];
}

@end