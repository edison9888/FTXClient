//
//  UIColor+FTX.h
//  FTXClient
//
//  Created by Lei Perry on 6/21/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

@interface UIColor (FTX)

+ (UIColor *)colorWithHex:(NSUInteger)color;
+ (UIColor *)colorWithHex:(NSUInteger)color alpha:(CGFloat)alpha;

- (CGFloat) red;
- (CGFloat) green;
- (CGFloat) blue;
- (CGFloat) alpha;

@end