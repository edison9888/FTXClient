//
//  UIView+FTX.h
//  FTXClient
//
//  Created by Lei Perry on 6/21/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

@interface UIView (FTX)

- (UIImage *)imageFromSelf;
- (UIView *)findFirstResponder;
- (UIViewController *)firstAvailableUIViewController;

@end