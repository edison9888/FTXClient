//
//  CommentViewController.m
//  FTXClient
//
//  Created by Lei Perry on 7/1/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CommentViewController.h"
#import "UIColor+FTX.h"
#import "UIImage+FTX.h"
#import "UIView+FTX.h"
#import "DetailViewController.h"

@interface CommentViewController ()
{
    Article *_article;
    UITextView *_commentLabel;
    UIScrollView *_scrollView;
    UIToolbar *_keyboardToolbar;
}
@end

@implementation CommentViewController

- (id)initWithArticle:(Article *)article {
    if (self = [super init]) {
        _article = article;
    }
    return self;
}

- (void)loadView {
    self.view = _scrollView = [[UIScrollView alloc] init];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:18];
    label.numberOfLines = 0;
    label.text = _article.title;
    label.textColor = [UIColor colorWithHex:0xdddddd];
    [self.view addSubview:label];

    CGSize size = [_article.title sizeWithFont:label.font constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    label.frame = CGRectMake(10, 20, 300, size.height);

    _commentLabel = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame)+20, 300, 100)];
    _commentLabel.keyboardAppearance = UIKeyboardAppearanceAlert;
    _commentLabel.delegate = self;
    _commentLabel.font = [UIFont systemFontOfSize:14];
    _commentLabel.textColor = [UIColor darkGrayColor];
    _commentLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _commentLabel.layer.cornerRadius = 4;
    [self.view addSubview:_commentLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 125, 44);
    button.center = CGPointMake(160, CGRectGetMaxY(_commentLabel.frame)+42);
    button.layer.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"button-gray-bg"] imageTintedWithColor:[UIColor colorWithHex:0xd24b00]]].CGColor;
    button.layer.cornerRadius = 4;
    [button setTitle:@"发表评论" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(postReview) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
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
    rightButton.clipsToBounds = YES;
    rightButton.layer.cornerRadius = 4;
    [rightButton setFrame:CGRectMake(0, 0, 36, 36)];
    [rightButton addTarget:self action:@selector(tapRightBarButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightView = [[UIView alloc] initWithFrame:buttonRect];
    rightView.backgroundColor = [UIColor colorWithWhite:1 alpha:.12];
    rightView.layer.cornerRadius = 5;
    [rightView addSubview:rightButton];
    rightButton.center = CGPointMake(CGRectGetWidth(buttonRect)/2, CGRectGetHeight(buttonRect)/2);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    // title
    self.title = @"评论";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfileStatus) name:kAccountChangeNotification object:DataMgr];
    [self updateProfileStatus];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    if (DataMgr.currentAccount == nil) {
        AccessAccountViewController *vc = [[AccessAccountViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAccountChangeNotification object:DataMgr];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)tapLeftBarButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapRightBarButton {
    AccessAccountViewController *vc = [[AccessAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateProfileStatus {
    UIView *view = self.navigationItem.rightBarButtonItem.customView;
    UIButton *button = (UIButton *)view.subviews[0];
    if ([DataMgr.currentAccount success]) {
        NSURL *imageURL = [NSURL URLWithString:DataMgr.currentAccount.avatarUrl];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
            });
        });
    }
    else {
        [button setImage:[UIImage imageNamed:@"icon-profile"] forState:UIControlStateNormal];
    }
}

- (void)postReview {
    NSString *path = [NSString stringWithFormat:@"/app/article/add_review?userId=%d&pwd=%@&authorId=%d&articleId=%d&content=%@", DataMgr.currentAccount.userId, DataMgr.currentAccount.password, _article.author.id, _article.id, [_commentLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    DLog(@"path=%@", path);
    [[AFFTXAPIClient sharedClient] getPath:path
                                parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id JSON) {
                                       DLog(@"comment: %@", JSON);
                                       if ([JSON[@"success"] boolValue]) {
                                           Review *review = [[Review alloc] initWithAttributes:JSON[@"review"]];
                                           self.detailViewController.addingReview = review;
                                           [self.navigationController popViewControllerAnimated:YES];
                                       }
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       DLog(@"error: %@", error.description);
                                   }];
}

- (void)dismissKeyboard:(id)sender
{
	[[self.view findFirstResponder] resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect beginRect = [[[notification userInfo] valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

	if (nil == _keyboardToolbar) {
        _keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        _keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
//        _keyboardToolbar.tintColor = [UIColor colorWithWhite:.5 alpha:.4];
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];
        barButtonItem.tintColor = [UIColor blueColor];
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        NSArray *items = [[NSArray alloc] initWithObjects:flex, barButtonItem, nil];
        [_keyboardToolbar setItems:items];
        
        _keyboardToolbar.frame = CGRectMake(beginRect.origin.x,
                                           beginRect.origin.y,
                                           _keyboardToolbar.frame.size.width,
                                           _keyboardToolbar.frame.size.height);
        [self.view addSubview:_keyboardToolbar];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    _keyboardToolbar.frame = CGRectMake(endRect.origin.x,
                                        endRect.origin.y-108,
                                        _keyboardToolbar.frame.size.width,
                                        _keyboardToolbar.frame.size.height);
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
//    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    CGRect endRect = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    _keyboardToolbar.frame = CGRectMake(endRect.origin.x,
                                        endRect.origin.y,
                                        _keyboardToolbar.frame.size.width,
                                        _keyboardToolbar.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
//    CGPoint targetPoint = CGPointMake(0, CGRectGetMinY(textView.frame) - 10);
//    targetPoint.y = fminf(targetPoint.y, 74);
//    [_scrollView setContentOffset:targetPoint animated:YES];
}


@end