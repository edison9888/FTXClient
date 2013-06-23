//
//  ArticleTableViewCell.m
//  FTXClient
//
//  Created by Lei Perry on 6/22/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ArticleTableViewCell.h"

@implementation ArticleTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setArticle:(Article *)article {
    _article = article;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

+ (CGFloat)heightForCellWithArticle:(Article *)article {
    return 44;
}

@end