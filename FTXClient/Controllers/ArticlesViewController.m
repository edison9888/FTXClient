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
#import "MBProgressHUD.h"

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
    
    PSCollectionView *_collectionView;
}
@end

@implementation ArticlesViewController

- (id)init {
    if (self = [super init]) {
        _articles = [NSMutableArray array];
        _articleIds = [NSMutableArray array];
        _currentPageNo = 1;
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
    [self refreshView:YES];
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

- (void)createHeaderView {
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    CGRect rect = self.view.bounds;
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -CGRectGetHeight(rect), CGRectGetWidth(rect), CGRectGetHeight(rect))];
    _refreshHeaderView.delegate = self;
    
	[_collectionView addSubview:_refreshHeaderView];
}

- (void)removeHeaderView {
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = nil;
}

- (void)setFooterView {
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(_collectionView.contentSize.height, _collectionView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f, height, _collectionView.frame.size.width, self.view.bounds.size.height);
    }
    else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f, height, _collectionView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [_collectionView addSubview:_refreshFooterView];
    }
}

- (void)removeFooterView {
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
        [self refreshView:NO];
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
        
    }
    
    [self setFooterView];
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

- (void)refreshView:(BOOL)clean {
    DLog(@"clean? %d", clean);

    // show header view
    _collectionView.contentOffset = CGPointMake(0, -65);
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    _collectionView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
    [UIView commitAnimations];

    if (clean) {
        [_articles removeAllObjects];
        [_articleIds removeAllObjects];
        [_collectionView reloadData];
        
        // retrieve from cache database
        NSString *q = @"SELECT * FROM Article AS A JOIN Article_Tag AS AT ON A.id=AT.articleId WHERE AT.tag = ? ORDER BY A.id DESC";
        FMResultSet *rs = [DataMgr.db executeQuery:q, @(DataMgr.categoryTag)];
        while ([rs next]) {
            Article *article = [[Article alloc] initWithResultSet:rs];
            [_articleIds addObject:@(article.id)];
            [_articles addObject:article];
        }
        
        // update interface
        [_collectionView reloadData];
        [self setFooterView];
    }
    
    NSString *path = [NSString stringWithFormat:@"/app/article/list?userId=%d&pwd=%@&tag=%d&pageNo=1", DataMgr.currentAccount.userId, DataMgr.currentAccount.password, DataMgr.categoryTag];
    DLog(@"path = %@", path);
    [[AFFTXAPIClient sharedClient] getPath:path
                                parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id JSON) {
                                       BOOL success = [JSON[@"success"] boolValue];
                                       if (success) {
                                           int tag = [JSON[@"tag"] integerValue];
                                           int maxId = [JSON[@"maxId"] integerValue];
                                           if ([_articleIds count] > 0 && maxId <= [_articleIds[0] integerValue]) {
                                               MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                               // Configure for text only and offset down
                                               hud.mode = MBProgressHUDModeText;
                                               hud.labelText = @"暂无更新";
                                               hud.margin = 10.f;
                                               hud.yOffset = -CGRectGetHeight(self.view.frame)/2+20;
                                               hud.removeFromSuperViewOnHide = YES;
                                               
                                               [hud hide:YES afterDelay:1];
                                           }
                                           
                                           //int minId = [JSON[@"minId"] integerValue];
                                           if (YES) {   //[_articleIds count] == 0 || maxId > [_articleIds[0] integerValue]) {
                                               NSArray *articles = JSON[@"articles"];
                                               for (int i=0; i<[articles count]; i++) {
                                                   @autoreleasepool {
                                                       Article *article = [[Article alloc] initWithAttributes:articles[i]];
                                                       if (![_articleIds containsObject:@(article.id)]) {
                                                           [_articleIds insertObject:@(article.id) atIndex:i];
                                                           [_articles insertObject:article atIndex:i];
                                                       }
                                                       else {
                                                           int idx = [_articleIds indexOfObject:@(article.id)];
                                                           Article *art = _articles[idx];
                                                           art.numOfComments = article.numOfComments;
                                                           art.numOfLikes = article.numOfLikes;
                                                           art.isLike = article.isLike;
                                                       }
                                                       
                                                       // cache articles
                                                       [DataMgr cacheArticle:article withTag:tag];
                                                   }
                                               }
                                               
                                               // update interface
                                               [_collectionView reloadData];
                                               [self setFooterView];
                                           }
                                           
                                           // finish loading status anyway
                                           [self finishReloadingData];
                                       }
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       DLog(@"error: %@", error.description);
                                       [self finishReloadingData];
                                   }];
}

- (void)getNextPageView {
    NSString *path = [NSString stringWithFormat:@"/app/article/list?userId=%d&pwd=%@&tag=%d&direction=1&pageNo=%d", DataMgr.currentAccount.userId, DataMgr.currentAccount.password, DataMgr.categoryTag, _currentPageNo+1];
    DLog(@"getNextPageView: %@", path);
    [[AFFTXAPIClient sharedClient] getPath:path
                                parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id JSON) {
                                       _currentPageNo++;
                                       int originalCount = [_articles count];
                                       int tag = [[JSON valueForKeyPath:@"tag"] integerValue];
                                       NSArray *postsFromResponse = [JSON valueForKeyPath:@"articles"];
                                       for (NSDictionary *attributes in postsFromResponse) {
                                           @autoreleasepool {
                                               Article *article = [[Article alloc] initWithAttributes:attributes];
                                               if (![_articleIds containsObject:@(article.id)]) {
                                                   [_articleIds addObject:@(article.id)];
                                                   [_articles addObject:article];
                                               }
                                               
                                               // cache articles
                                               [DataMgr cacheArticle:article withTag:tag];
                                               
                                               [self removeFooterView];
                                               [self finishReloadingData];
                                           }
                                       }
                                       
                                       [_collectionView reloadData];
                                       [self setFooterView];
                                       
                                       if ([_articles count] == originalCount) {
                                           MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                           // Configure for text only and offset down
                                           hud.mode = MBProgressHUDModeText;
                                           hud.labelText = @"暂无更新";
                                           hud.margin = 10.f;
                                           hud.yOffset = CGRectGetHeight(self.view.frame)/2-28;
                                           hud.removeFromSuperViewOnHide = YES;
                                           
                                           [hud hide:YES afterDelay:1];
                                       }
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       DLog(@"error: %@", error.description);
                                   }];
}

@end