//
//  CategoryPIckerView.m
//  FTXClient
//
//  Created by Lei Perry on 6/21/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "CategoryPIckerView.h"

@interface CategoryPickerView ()
{
    UIImageView *_bgView;
}
@end

@implementation CategoryPickerView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category-item-bg"]];
        _bgView.frame = CGRectMake(-60, 0, 60, 40);
        [self addSubview:_bgView];
        
        NSArray *images = @[@"basketball", @"football", @"fun",  @"video"];
        for (int i=0; i<[images count]; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(20 + i*70, 0, 60, CGRectGetHeight(frame));
            button.tag = i+1;
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
    self.selectedIndex = button.tag;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (_selectedIndex != selectedIndex) {
        CGRect from = _bgView.frame;
        CGRect to = CGRectMake(20 + (selectedIndex-1) * 70, 0, 60, 40);
        
        _bgView.frame = from;
        [UIView animateWithDuration:.2
                         animations:^{
                             _bgView.frame = to;
                         }];
        
        _selectedIndex = selectedIndex;
        DataMgr.categoryIndex = selectedIndex;
    }
}

@end