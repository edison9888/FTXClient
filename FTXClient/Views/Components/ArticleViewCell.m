//
//  ArticleViewCell.m
//  FTXClient
//
//  Created by Lei Perry on 7/3/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "ArticleViewCell.h"
#import "UIColor+FTX.h"
#import "UIImage+FTX.h"
#import "UIImageView+AFNetworking.h"

#define MARGIN 4.0

@interface ArticleViewCell ()
{
    UILabel *_titleLabel;
}

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ArticleViewCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0x333333];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor colorWithHex:0xdddddd];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _imageView.image = nil;
    _titleLabel.text = nil;
}

- (void)dealloc {
    _imageView = nil;
    _titleLabel = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    // Image
    CGFloat objectWidth = 250;
    CGFloat objectHeight = _article.imageHeight;
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    _imageView.frame = CGRectMake(0, 0, width, scaledHeight);
    
    CGFloat topOffset = scaledHeight + MARGIN;
    
    // Label
    CGSize labelSize = CGSizeZero;
    labelSize = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(width - 2 * MARGIN, CGFLOAT_MAX) lineBreakMode:_titleLabel.lineBreakMode];
    
    _titleLabel.frame = CGRectMake(MARGIN, topOffset, labelSize.width, labelSize.height);
}

- (void)setArticle:(Article *)article {
    [super setObject:article];
    _article = article;
    
    _titleLabel.text = article.title;
    if (article.image) {
        _imageView.image = article.image;
    }
    else {
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:article.imageUrl]];
        [req addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        __block ArticleViewCell *cell = self;
        [_imageView setImageWithURLRequest:req
                          placeholderImage:[UIImage imageNamed:@"cell-image-placeholder"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                       DLog(@"%@xxx", NSStringFromCGSize(image.size));
                                       cell.imageView.image = article.image = image;
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                       DLog(@"failed: %@", error.description);
                                   }];
    }
}

+ (CGFloat)rowHeightForObject:(id)object inColumnWidth:(CGFloat)columnWidth {
    CGFloat height = 0.0;
    CGFloat width = columnWidth;
    
    Article *article = (Article *)object;
    // Image
    CGFloat objectWidth = 250;
    CGFloat objectHeight = article.imageHeight;
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    height += scaledHeight;
    
    // Label
    NSString *caption = article.title;
    CGSize labelSize = CGSizeZero;
    UIFont *labelFont = [UIFont boldSystemFontOfSize:14.0];
    labelSize = [caption sizeWithFont:labelFont constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    height += labelSize.height + 2 * MARGIN;
    
    height += 60;
    
    return height;
}

@end