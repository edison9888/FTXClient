//
//  ArticleTableViewCell.h
//  FTXClient
//
//  Created by Lei Perry on 6/22/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import "Article.h"

@interface ArticleTableViewCell : UITableViewCell

@property (nonatomic, strong) Article *article;

+ (CGFloat)heightForCellWithArticle:(Article *)article;

@end