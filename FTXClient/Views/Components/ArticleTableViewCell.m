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
#import "CustomIconButton.h"
#import "UMSocial.h"
#import "CommentViewController.h"
#import "DetailViewController.h"

#define MAX_IMAGE_HEIGHT 355
#define FIX_IMAGE_HEIGHT 260

@interface ArticleTableViewCell ()
{
    UIImageView *_imageView;
    CustomIconButton *_likeButton, *_commentButton, *_shareButton, *_relevantButton;
    UIScrollView *_scrollView;
}

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ArticleTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor blackColor];
        self.backgroundView = bgView;
        UIView *selectedBgView = [[UIView alloc] initWithFrame:self.bounds];
        selectedBgView.backgroundColor = [UIColor colorWithWhite:1 alpha:.1];
        self.selectedBackgroundView = selectedBgView;
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:17];
        self.textLabel.numberOfLines = 0;
        self.textLabel.textColor = [UIColor colorWithHex:0xdddddd];

        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textColor = [UIColor colorWithHex:0xbbbbbb];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 20, 300, FIX_IMAGE_HEIGHT)];
        _scrollView.userInteractionEnabled = NO;
        [self addSubview:_scrollView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_imageView];

        _likeButton = [CustomIconButton buttonWithType:UIButtonTypeCustom];
        _likeButton.imageOriginX = 8;
        _likeButton.titleOriginX = 32;
        _likeButton.backgroundColor = [UIColor colorWithHex:0xff5f3e];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_likeButton addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];
        [_likeButton setImage:[UIImage imageNamed:@"cell-icon-heart"] forState:UIControlStateNormal];
        [self addSubview:_likeButton];
        
        _commentButton = [CustomIconButton buttonWithType:UIButtonTypeCustom];
        _commentButton.imageOriginX = 8;
        _commentButton.titleOriginX = 32;
        _commentButton.backgroundColor = [UIColor colorWithHex:0x0091cb];
        _commentButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_commentButton addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
        [_commentButton setImage:[UIImage imageNamed:@"cell-icon-bubble"] forState:UIControlStateNormal];
        [self addSubview:_commentButton];
        
        _shareButton = [CustomIconButton buttonWithType:UIButtonTypeCustom];
        _shareButton.imageOriginX = 5;
        _shareButton.titleOriginX = 26;
        _shareButton.backgroundColor = [UIColor colorWithHex:0x007740];
        _shareButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [_shareButton setImage:[UIImage imageNamed:@"cell-icon-share"] forState:UIControlStateNormal];
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [self addSubview:_shareButton];
        
        _relevantButton = [CustomIconButton buttonWithType:UIButtonTypeCustom];
        _relevantButton.titleOriginX = 30;
        _relevantButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_relevantButton setBackgroundImage:[UIImage imageNamed:@"cell-icon-badge"] forState:UIControlStateNormal];
        [_relevantButton addTarget:self action:@selector(relevantAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_relevantButton];
    }
    return self;
}

- (void)dealloc {
    _favoritesController = nil;
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
//        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    else {
        NSString *docDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *imageFile = [docDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"images/%@", article.imageId]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:imageFile]) {
            article.image = _imageView.image = [UIImage imageWithContentsOfFile:imageFile];
//            _imageView.contentMode = UIViewContentModeScaleAspectFill;
        }
        else {
            NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:article.imageUrl]];
            [req addValue:@"image/*" forHTTPHeaderField:@"Accept"];
            __block ArticleTableViewCell *cell = self;
            [_imageView setImageWithURLRequest:req
                              placeholderImage:[UIImage imageNamed:@"cell-image-placeholder"]
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                           cell.imageView.image = article.image = image;
//                                           cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = 300;
    // Image
    CGFloat objectWidth = 250;
    CGFloat objectHeight = _article.imageHeight;
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    _imageView.frame = CGRectMake(0, 0, width, scaledHeight);
    _imageView.image = _article.image;

    _relevantButton.frame = CGRectMake(255, 30, 60, 23);

    CGFloat topOffset = FIX_IMAGE_HEIGHT + 25;
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
    
    _likeButton.frame = CGRectMake(10, topOffset, 66, 28);
    _commentButton.frame = CGRectMake(76, topOffset, 66, 28);
    _shareButton.frame = CGRectMake(253, topOffset, 57, 28);
    
    _likeButton.hidden = _commentButton.hidden = _shareButton.hidden = isEmpty(_article.image);
    _relevantButton.hidden = isEmpty(_article.image) || _article.numOfRelevants == 0;
}

+ (CGFloat)heightForCellWithArticle:(Article *)article {
    CGFloat h = FIX_IMAGE_HEIGHT + 20;
    
    if (article.title) {
        h += [article.title sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height;
        h += 10;
    }
    if (article.summary) {
        h += [article.summary sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height;
        h += 10;
    }
    h += 38;    // 28 for buttons + 10 for bottom padding
    return h;
}

- (void)likeAction {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"你确定取消喜欢这篇文章吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"是"
                                              otherButtonTitles:@"否",
                              nil];
    [alertView show];
}

- (void)commentAction {
    DetailViewController *vc = [[DetailViewController alloc] initWithArticle:_article navigatable:NO];
    vc.animateToComments = YES;
    [[HomeViewController sharedHome].navigationController pushViewController:vc animated:YES];
}

- (void)shareAction {
    if (DataMgr.currentAccount == nil) {
        AccessAccountViewController *vc = [[AccessAccountViewController alloc] init];
        vc.loginView.promptLabel.text = @"请登录后分享";
        [[HomeViewController sharedHome].navigationController pushViewController:vc animated:YES];
        return;
    }
    
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeOther;
    WXWebpageObject *webObject = [WXWebpageObject object];
    webObject.webpageUrl = [NSString stringWithFormat:@"%@/discover/%d/%d", StagingBoxInterfaceBase, _article.author.id, _article.id];
    [UMSocialData defaultData].extConfig.wxMediaObject = webObject;
    
    [UMSocialSnsService presentSnsIconSheetView:[HomeViewController sharedHome]
                                         appKey:kUMengAppKey
                                      shareText:_article.title
                                     shareImage:_article.image
                                shareToSnsNames:@[UMShareToSina, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]
                                       delegate:nil];
}

- (void)relevantAction {
    DLog(@"relevant");
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        NSString *path = [NSString stringWithFormat:@"/app/article/like?userId=%d&pwd=%@&authorId=%d&articleId=%d&flag=%d", DataMgr.currentAccount.userId, DataMgr.currentAccount.password, _article.author.id, _article.id, !_article.isLike];
        [[AFFTXAPIClient sharedClient] getPath:path
                                    parameters:nil
                                       success:^(AFHTTPRequestOperation *operation, id JSON) {
                                           DLog(@"like: %@", JSON);
                                           if ([JSON[@"success"] boolValue]) {
                                               [_likeButton setImage:[UIImage imageNamed:@"cell-icon-heart"] forState:UIControlStateNormal];
                                               _article.isLike = NO;
                                               _article.numOfLikes = [JSON[@"likeCount"] integerValue];
                                               
                                               UITableView *table = (UITableView *)self.superview;
                                               NSIndexPath *indexPath = [table indexPathForCell:self];
                                               [self.favoritesController deleteFavoriteAtIndexPath:indexPath];
                                           }
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           DLog(@"error: %@", error.description);
                                       }];
    }
}

@end