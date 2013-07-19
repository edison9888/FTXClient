//
//  ArticlesViewController.h
//  FTXClient
//
//  Created by Lei Perry on 7/3/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import "PSCollectionView.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface ArticlesViewController : UIViewController <PSCollectionViewDataSource, PSCollectionViewDelegate, EGORefreshTableDelegate, UIScrollViewDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
}

@property (nonatomic, readonly) NSMutableArray *articles;
@property (nonatomic) NSUInteger currentPageNo;

-(void)refreshView:(BOOL)clean;

@end