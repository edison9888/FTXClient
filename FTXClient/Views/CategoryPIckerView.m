//
//  CategoryPIckerView.m
//  FTXClient
//
//  Created by Lei Perry on 6/21/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "CategoryPIckerView.h"

@implementation CategoryPickerView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
        NSArray *images = @[@"basketball", @"football", @"fun", @"sexy", @"video"];
        for (int i=0; i<[images count]; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(10 + i*60, 0, 60, CGRectGetHeight(frame));
            button.tag = i + 1;
            [button setBackgroundImage:[UIImage imageNamed:@"category-item-bg"] forState:UIControlStateSelected];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"category-%@", images[i]]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(tapCategory:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
    return self;
}

- (void)tapCategory:(UIButton *)button {
    for (int i=1; i<=5; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:i];
        btn.selected = (button == btn);
    }
    DLog(@"category: %d", button.tag);
}

@end