//
//  CategoryPIckerView.m
//  FTXClient
//
//  Created by Lei Perry on 6/21/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "CategoryPIckerView.h"

static NSArray *tags;

@implementation CategoryPickerView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        if (tags == nil)
            tags = @[@(CategoryTypeBasketball), @(CategoryTypeFootball), @(CategoryTypeFun),  @(CategoryTypeVideo)];
        
        NSArray *images = @[@"basketball", @"football", @"fun",  @"video"];
        for (int i=0; i<[images count]; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(20 + i*70, 0, 60, CGRectGetHeight(frame));
            button.tag = [tags[i] integerValue];
            [button setBackgroundImage:[UIImage imageNamed:@"category-item-bg"] forState:UIControlStateSelected];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"category-%@", images[i]]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(tapCategory:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-1, CGRectGetWidth(frame), 1)];
        line.image = [UIImage imageNamed:@"category-picker-line"];
        [self addSubview:line];
    }
    return self;
}

- (void)tapCategory:(UIButton *)button {
    for (int i=0; i<[tags count]; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:[tags[i] integerValue]];
        btn.selected = (button == btn);
    }
    DLog(@"category: %d", button.tag);
    DataMgr.categoryTag = button.tag;
}

@end