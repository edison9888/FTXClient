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
#import "CustomIconButton.h"
#import "CommentViewController.h"
#import "HomeViewController.h"
#import "DetailViewController.h"

#define MAX_IMAGE_HEIGHT 355

@interface ArticleViewCell ()
{
    UILabel *_titleLabel;
    CustomIconButton *_likeButton, *_commentButton, *_relevantButton;
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
        _imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor colorWithHex:0xdddddd];
        [self addSubview:_titleLabel];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-23, CGRectGetWidth(frame), 1)];
        line.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        line.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];
        [self addSubview:line];
        
        UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-22, CGRectGetWidth(frame), 22)];
        bar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        bar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell-bar-pattern"]];
        [self addSubview:bar];
        
        _likeButton = [CustomIconButton buttonWithType:UIButtonTypeCustom];
        _likeButton.imageOriginX = 5;
        _likeButton.titleOriginX = 18;
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_likeButton addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];
        [_likeButton setImage:[UIImage imageNamed:@"cell-bar-heart"] forState:UIControlStateNormal];
        [_likeButton setTitleColor:[UIColor colorWithHex:0xbbbbbb] forState:UIControlStateNormal];
        [bar addSubview:_likeButton];
        
        _commentButton = [CustomIconButton buttonWithType:UIButtonTypeCustom];
        _commentButton.imageOriginX = 5;
        _commentButton.titleOriginX = 18;
        _commentButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_commentButton addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
        [_commentButton setImage:[UIImage imageNamed:@"cell-bar-comment"] forState:UIControlStateNormal];
        [_commentButton setTitleColor:[UIColor colorWithHex:0xbbbbbb] forState:UIControlStateNormal];
        [bar addSubview:_commentButton];
        
        _relevantButton = [CustomIconButton buttonWithType:UIButtonTypeCustom];
        _relevantButton.imageOriginX = 5;
        _relevantButton.titleOriginX = 18;
        _relevantButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_relevantButton setImage:[UIImage imageNamed:@"cell-bar-relevant"] forState:UIControlStateNormal];
        [_relevantButton addTarget:self action:@selector(relevantAction) forControlEvents:UIControlEventTouchUpInside];
        [_relevantButton setTitleColor:[UIColor colorWithHex:0xbbbbbb] forState:UIControlStateNormal];
        [bar addSubview:_relevantButton];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _imageView.contentMode = UIViewContentModeCenter;
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
    scaledHeight = fminf(MAX_IMAGE_HEIGHT, scaledHeight);
    _imageView.frame = CGRectMake(0, 0, width, scaledHeight);
    
    CGFloat topOffset = scaledHeight + 5;
    
    // Label
    CGSize labelSize = CGSizeZero;
    labelSize = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(width - 12, CGFLOAT_MAX) lineBreakMode:_titleLabel.lineBreakMode];
    
    _titleLabel.frame = CGRectMake(6, topOffset, labelSize.width, labelSize.height);
    
    CGSize size = [[NSString stringWithFormat:@"%d", _article.numOfLikes] sizeWithFont:_likeButton.titleLabel.font];
    _likeButton.frame = CGRectMake(0, 0, size.width + 23, 22);
    
    size = [[NSString stringWithFormat:@"%d", _article.numOfComments] sizeWithFont:_commentButton.titleLabel.font];
    _commentButton.frame = CGRectMake(CGRectGetMaxX(_likeButton.frame), 0, size.width + 23, 22);
    
    size = [[NSString stringWithFormat:@"%d", _article.numOfRelevants] sizeWithFont:_relevantButton.titleLabel.font];
    _relevantButton.frame = CGRectMake(width - size.width - 23, 0, size.width + 23, 22);
}

- (void)setArticle:(Article *)article {
    [super setObject:article];
    _imageView.contentMode = UIViewContentModeCenter;
    _article = article;
    
    _titleLabel.text = article.title;
    [_likeButton setTitle:[NSString stringWithFormat:@"%d", article.numOfLikes] forState:UIControlStateNormal];
    [_commentButton setTitle:[NSString stringWithFormat:@"%d", article.numOfComments] forState:UIControlStateNormal];
    [_relevantButton setTitle:[NSString stringWithFormat:@"%d", article.numOfRelevants] forState:UIControlStateNormal];

    if (article.image) {
        _imageView.image = article.image;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    else {
        NSString *docDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *imageFile = [docDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"images/%@", article.imageId]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:imageFile]) {
            article.image = _imageView.image = [UIImage imageWithContentsOfFile:imageFile];
            _imageView.contentMode = UIViewContentModeScaleAspectFill;
        }
        else {
            NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:article.imageUrl]];
            [req addValue:@"image/*" forHTTPHeaderField:@"Accept"];
            __block ArticleViewCell *cell = self;
            [_imageView setImageWithURLRequest:req
                              placeholderImage:[UIImage imageNamed:@"cell-image-placeholder"]
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                           cell.imageView.image = article.image = image;
                                           cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
                                           dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
                                           dispatch_async(queue, ^{
                                               // save uiimage to file
                                               NSData *data = UIImagePNGRepresentation(article.image);
                                               if (![data writeToFile:imageFile atomically:YES])
                                                   DLog(@"write image file failed for article(%d)", article.id);
                                           });
                                       }
                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                           DLog(@"failed: %@", error.description);
                                       }];
        }
    }
    [self setNeedsLayout];
}

+ (CGFloat)rowHeightForObject:(id)object inColumnWidth:(CGFloat)columnWidth {
    CGFloat height = 0.0;
    CGFloat width = columnWidth;
    
    Article *article = (Article *)object;
    // Image
    CGFloat objectWidth = 250;
    CGFloat objectHeight = article.imageHeight;
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    height += fminf(MAX_IMAGE_HEIGHT, scaledHeight);
    
    // Label
    NSString *caption = article.title;
    CGSize labelSize = CGSizeZero;
    UIFont *labelFont = [UIFont boldSystemFontOfSize:14.0];
    labelSize = [caption sizeWithFont:labelFont constrainedToSize:CGSizeMake(width-12, INT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    height += labelSize.height + 33;
        
    return height;
}

- (void)likeAction {
    DLog(@"like");
}

- (void)commentAction {
    DetailViewController *vc = [[DetailViewController alloc] initWithArticle:_article];
    vc.animateToComments = YES;
    [[HomeViewController sharedHome].navigationController pushViewController:vc animated:YES];
}

- (void)relevantAction {
    DLog(@"relevant");
}

@end