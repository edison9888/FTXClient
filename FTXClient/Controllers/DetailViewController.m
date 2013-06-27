//
//  DetailViewController.m
//  FTXClient
//
//  Created by Lei Perry on 6/26/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import "AccessAccountViewController.h"
#import "CustomIconButton.h"
#import "UIColor+FTX.h"
#import "UIImage+FTX.h"
#import "UIImageView+AFNetworking.h"

@interface DetailViewController ()
{
    UIScrollView *scrollView;
    UIImageView *_avatarView, *_imageView;
    UILabel *_authorNameLabel, *_publishLabel;
    UILabel *_titleLabel, *_contentLabel;
    CustomIconButton *_likeButton, *_commentButton, *_shareButton;
}

@end

@implementation DetailViewController

static NSDateFormatter* formatter = nil;

- (id)initWithArticle:(Article *)article {
    if (self = [super init]) {
        _article = article;
        if (nil == formatter) {
            formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd hh:mm";
            formatter.locale = [NSLocale currentLocale];
        }
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table-cell-bg"]];
    [self.view addSubview:bgImageView];
    
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    rect = CGRectMake(10, 0, 300, CGRectGetHeight(rect)-44-28);
    scrollView = [[UIScrollView alloc] initWithFrame:rect];
    [self.view addSubview:scrollView];
    
    _likeButton = [CustomIconButton buttonWithType:UIButtonTypeCustom];
    _likeButton.imageOriginX = 8;
    _likeButton.titleOriginX = 32;
    _likeButton.backgroundColor = [UIColor colorWithHex:0xff5f3e];
    _likeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _likeButton.frame = CGRectMake(10, CGRectGetHeight(rect), 66, 28);
    [_likeButton addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];
    [_likeButton setImage:[UIImage imageNamed:@"cell-icon-heart"] forState:UIControlStateNormal];
    [_likeButton setTitle:[NSString stringWithFormat:@"%d", _article.numOfLikes] forState:UIControlStateNormal];
    [self.view addSubview:_likeButton];
    
    _commentButton = [CustomIconButton buttonWithType:UIButtonTypeCustom];
    _commentButton.imageOriginX = 8;
    _commentButton.titleOriginX = 32;
    _commentButton.backgroundColor = [UIColor colorWithHex:0x0091cb];
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _commentButton.frame = CGRectMake(76, CGRectGetHeight(rect), 66, 28);
    [_commentButton addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [_commentButton setImage:[UIImage imageNamed:@"cell-icon-bubble"] forState:UIControlStateNormal];
    [_commentButton setTitle:[NSString stringWithFormat:@"%d", _article.numOfComments] forState:UIControlStateNormal];
    [self.view addSubview:_commentButton];
    
    _shareButton = [CustomIconButton buttonWithType:UIButtonTypeCustom];
    _shareButton.imageOriginX = 5;
    _shareButton.titleOriginX = 26;
    _shareButton.backgroundColor = [UIColor colorWithHex:0x007740];
    _shareButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _shareButton.frame = CGRectMake(253, CGRectGetHeight(rect), 57, 28);
    [_shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [_shareButton setImage:[UIImage imageNamed:@"cell-icon-share"] forState:UIControlStateNormal];
    [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [self.view addSubview:_shareButton];
    
    // scrollable content
    _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 30, 30)];
    [scrollView addSubview:_avatarView];
    
    _authorNameLabel = [[UILabel alloc] init];
    _authorNameLabel.backgroundColor = [UIColor clearColor];
    _authorNameLabel.font = [UIFont systemFontOfSize:14];
    _authorNameLabel.textColor = [UIColor colorWithHex:0xbbbbbb];
    [scrollView addSubview:_authorNameLabel];
    _authorNameLabel.text = _article.author.name;

    _publishLabel = [[UILabel alloc] init];
    _publishLabel.backgroundColor = [UIColor clearColor];
    _publishLabel.font = [UIFont systemFontOfSize:13];
    _publishLabel.textColor = [UIColor colorWithHex:0xbbbbbb];
    [scrollView addSubview:_publishLabel];
    NSString *date = [NSString stringWithFormat:@"发布于%@", [formatter stringFromDate:_article.publishTime]];
    _publishLabel.text = date;

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textColor = [UIColor colorWithHex:0xdddddd];
    [scrollView addSubview:_titleLabel];
    _titleLabel.text = _article.title;
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = [UIColor colorWithHex:0xbbbbbb];
    [scrollView addSubview:_contentLabel];
    _contentLabel.text = _article.content;
    
    if (!isEmpty(_article.imageUrl)) {
        _imageView = [[UIImageView alloc] init];
        [scrollView addSubview:_imageView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect buttonRect = CGRectMake(0, 0, 44, 44);
    buttonRect = CGRectInset(buttonRect, 4, 4);
    
    // left bar button
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton setImage:[UIImage imageNamed:@"icon-back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(tapLeftBarButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *leftView = [[UIView alloc] initWithFrame:buttonRect];
    leftView.backgroundColor = [UIColor colorWithWhite:1 alpha:.12];
    leftView.layer.cornerRadius = 5;
    [leftView addSubview:leftButton];
    leftButton.center = CGPointMake(CGRectGetWidth(buttonRect)/2, CGRectGetHeight(buttonRect)/2);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    
    
    // right bar button
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setImage:[UIImage imageNamed:@"icon-profile"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(tapRightBarButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightView = [[UIView alloc] initWithFrame:buttonRect];
    rightView.backgroundColor = [UIColor colorWithWhite:1 alpha:.12];
    rightView.layer.cornerRadius = 5;
    [rightView addSubview:rightButton];
    rightButton.center = CGPointMake(CGRectGetWidth(buttonRect)/2, CGRectGetHeight(buttonRect)/2);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    // title
    self.title = @"饭特稀体育";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_avatarView setImageWithURL:[NSURL URLWithString:_article.author.avatar] placeholderImage:[UIImage imageNamed:@"avatar-placeholder"]];
    if (_article.image) {
        _imageView.image = _article.image;
        _imageView.frame = CGRectMake(0, 0, _article.image.size.width, _article.image.size.height);
    }
    else if (!isEmpty(_article.imageUrl)){
        __block Article *article = _article;
        __block DetailViewController *viewController = self;
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_article.imageUrl]];
        [req addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        [_imageView setImageWithURLRequest:req
                          placeholderImage:[UIImage imageNamed:@"cell-image-placeholder"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                       dispatch_queue_t main_queue = dispatch_get_main_queue();
                                       dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
                                       dispatch_async(queue, ^{
                                           CGFloat h = image.size.height * 300 / image.size.width;
                                           article.image = [image scaleToSize:CGSizeMake(300, h)];
                                           dispatch_sync(main_queue, ^{
                                               [viewController layoutViews];
                                           });
                                       });
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){}];
    }

    [self layoutViews];
}

- (void)layoutViews {
    CGSize size = [_authorNameLabel.text sizeWithFont:_authorNameLabel.font];
    _authorNameLabel.frame = CGRectMake(40, 50-size.height, size.width, size.height);
    
    size = [_publishLabel.text sizeWithFont:_publishLabel.font];
    _publishLabel.frame = CGRectMake(CGRectGetMaxX(_authorNameLabel.frame)+10, 50-size.height, size.width, size.height);
    
    int topOffset = 70;
    if (!isEmpty(_titleLabel.text)) {
        size = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
        _titleLabel.frame = CGRectMake(0, topOffset, 300, size.height);
        topOffset += size.height + 10;
    }
    
    if (!isEmpty(_contentLabel.text)) {
        size = [_contentLabel.text sizeWithFont:_contentLabel.font constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
        _contentLabel.frame = CGRectMake(0, topOffset, 300, size.height);
        topOffset += size.height + 10;
    }
    
    if (_imageView.image) {
        _imageView.frame = CGRectMake(0, topOffset, _imageView.image.size.width, _imageView.image.size.height);
        topOffset += _imageView.image.size.height + 10;
    }
    
    
    
    scrollView.contentSize = CGSizeMake(300, topOffset);
}

- (void)tapLeftBarButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapRightBarButton {
    AccessAccountViewController *vc = [[AccessAccountViewController alloc] initWithLogin:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - actions
- (void)likeAction {
    DLog(@"like");
}

- (void)commentAction {
    DLog(@"comment");
}

- (void)shareAction {
    DLog(@"share");
}


@end