//
//  ArticleTableViewCell.m
//  FTXClient
//
//  Created by Lei Perry on 6/22/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ArticleTableViewCell.h"
#import "UIColor+FTX.h"
#import "UIImageView+AFNetworking.h"

@interface ArticleTableViewCell ()
{
    UIImageView *_imageView, *_imageMaskView;
    UIButton *_likeButton, *_commentButton, *_shareButton, *_relevantButton;
}
@end

@implementation ArticleTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-cell-bg"]];
        self.backgroundView = bgView;
        UIView *selectedBgView = [[UIView alloc] initWithFrame:self.bounds];
        selectedBgView.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];
        self.selectedBackgroundView = selectedBgView;
        
        self.textLabel.font = [UIFont systemFontOfSize:17];
        self.textLabel.numberOfLines = 0;
        self.textLabel.textColor = [UIColor colorWithHex:0xdddddd];

        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textColor = [UIColor colorWithHex:0xbbbbbb];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 160)];
        [self addSubview:_imageView];
        
        _imageMaskView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 218, 160)];
        _imageMaskView.image = [UIImage imageNamed:@"cell-image-mask"];
        [self addSubview:_imageMaskView];
        
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.backgroundColor = [UIColor colorWithHex:0xff5f3e];
        [_likeButton addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_likeButton];
        
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentButton.backgroundColor = [UIColor colorWithHex:0x0091cb];
        [_commentButton addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_commentButton];
        
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.backgroundColor = [UIColor colorWithHex:0x007740];
        [_shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_shareButton];
    }
    return self;
}

- (void)setArticle:(Article *)article {
    _article = article;
    self.textLabel.text = article.title;
    self.detailTextLabel.text = article.summary;
    [_imageView setImageWithURL:[NSURL URLWithString:article.image]];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat topOffset = 20;
    CGRect rect;
    
    if (_article.title) {
        rect = self.textLabel.frame;
        rect.origin = CGPointMake(10, topOffset);
        rect.size.width = 300;
        self.textLabel.frame = rect;
        topOffset += CGRectGetHeight(rect) + 10;
    }
    
    if (_article.summary) {
        rect = self.detailTextLabel.frame;
        rect.origin = CGPointMake(10, topOffset);
        rect.size.width = 300;
        self.detailTextLabel.frame = rect;
        topOffset += CGRectGetHeight(rect) + 10;
    }
    
    rect = _imageView.frame;
    rect.origin = CGPointMake(10, topOffset);
    _imageView.frame = rect;
    rect = _imageMaskView.frame;
    rect.origin.y = topOffset;
    _imageMaskView.frame = rect;
    topOffset += 160;
    
    _likeButton.frame = CGRectMake(10, topOffset, 66, 28);
    _commentButton.frame = CGRectMake(76, topOffset, 66, 28);
    _shareButton.frame = CGRectMake(253, topOffset, 57, 28);
}

+ (CGFloat)heightForCellWithArticle:(Article *)article {
    CGFloat h = 20;
    if (article.title) {
        h += [article.title sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height;
        h += 10;
    }
    if (article.summary) {
        h += [article.summary sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height;
        h += 10;
    }
    if (article.image) {
        h += 160;
    }
    h += 38;    // 28 for buttons + 10 for bottom padding
    DLog(@"height for %@: %f", article.title, h);
    return h;
}

- (void)likeAction {
    DLog(@"like");
}

- (void)commentAction {
    DLog(@"comment");
}

- (void)shareAction {
    DLog(@"share");
}

- (void)relevantAction {
    DLog(@"relevant");
}

@end