//
//  CustomIconButton.m
//  FTXClient
//
//  Created by Lei Perry on 6/23/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "CustomIconButton.h"

@implementation CustomIconButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.titleLabel.frame;
    rect.origin.x = _titleOriginX;
    self.titleLabel.frame = rect;
    
    rect = self.imageView.frame;
    rect.origin.x = _imageOriginX;
    self.imageView.frame = rect;
}

@end