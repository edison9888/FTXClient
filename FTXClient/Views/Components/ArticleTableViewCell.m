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
#import "UIImage+FTX.h"
#import "UIImageView+AFNetworking.h"
#import "HomeViewController.h"

@interface ArticleTableViewCell ()
{
    UIImageView *_imageView;
    UIButton *_likeButton, *_commentButton, *_shareButton, *_relevantButton;
}

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ArticleTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-cell-bg"]];
        self.backgroundView = bgView;
        UIView *selectedBgView = [[UIView alloc] initWithFrame:self.bounds];
        selectedBgView.backgroundColor = [UIColor colorWithWhite:1 alpha:.1];
        self.selectedBackgroundView = selectedBgView;
        
        self.textLabel.font = [UIFont systemFontOfSize:17];
        self.textLabel.numberOfLines = 0;
        self.textLabel.textColor = [UIColor colorWithHex:0xdddddd];

        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textColor = [UIColor colorWithHex:0xbbbbbb];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 160)];
        _imageView.image = [UIImage imageNamed:@"cell-image-placeholder"];
        [self addSubview:_imageView];
        
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.backgroundColor = [UIColor colorWithHex:0xff5f3e];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_likeButton addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_likeButton];
        
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentButton.backgroundColor = [UIColor colorWithHex:0x0091cb];
        _commentButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_commentButton addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_commentButton];
        
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.backgroundColor = [UIColor colorWithHex:0x007740];
        _shareButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_shareButton];
    }
    return self;
}

- (void)setArticle:(Article *)article {
    _article = article;
    self.textLabel.text = article.title;
    self.detailTextLabel.text = article.summary;
    [_likeButton setTitle:[NSString stringWithFormat:@"%d", article.numOfLikes] forState:UIControlStateNormal];
    [_commentButton setTitle:[NSString stringWithFormat:@"%d", article.numOfComments] forState:UIControlStateNormal];
    [_relevantButton setTitle:[NSString stringWithFormat:@"%d", article.numOfRelevants] forState:UIControlStateNormal];

    if (article.image) {
        _imageView.image = article.image;
    }
    else {
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:article.imageUrl]];
        [req addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        __block ArticleTableViewCell *cell = self;
        [_imageView setImageWithURLRequest:req
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                       dispatch_queue_t main_queue = dispatch_get_main_queue();
                                       dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
                                       dispatch_async(queue, ^{
                                           CGFloat h = image.size.height * 300 / image.size.width;
                                           article.image = [image scaleToSize:CGSizeMake(300, h)];
                                           dispatch_sync(main_queue, ^{
                                               if ([[HomeViewController sharedHome].tableViewController.tableView.visibleCells containsObject:cell]) {
                                                   NSIndexPath *indexPath = [[HomeViewController sharedHome].tableViewController.tableView indexPathForCell:cell];
                                                   [[HomeViewController sharedHome].tableViewController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                               }
                                           });
                                       });
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){}];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat topOffset = 20;
    CGRect rect;
    
    if (!isEmpty(_article.title)) {
        rect = self.textLabel.frame;
        rect.origin = CGPointMake(10, topOffset);
        rect.size.width = 300;
        self.textLabel.frame = rect;
        topOffset += CGRectGetHeight(rect) + 10;
    }
    
    if (!isEmpty(_article.summary)) {
        rect = self.detailTextLabel.frame;
        rect.origin = CGPointMake(10, topOffset);
        rect.size.width = 300;
        self.detailTextLabel.frame = rect;
        topOffset += CGRectGetHeight(rect) + 10;
    }

    rect = _imageView.frame;
    rect.origin = CGPointMake(10, topOffset);
    if (_article.image)
        rect.size = _article.image.size;
    _imageView.frame = rect;
    topOffset += CGRectGetHeight(_imageView.frame);
    
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
    if (article.imageUrl) {
        h += article.image ? article.image.size.height : 160;
    }
    h += 38;    // 28 for buttons + 10 for bottom padding
//    if (h > 58)
//        DLog(@"height for %@: %f", article.title, h);
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