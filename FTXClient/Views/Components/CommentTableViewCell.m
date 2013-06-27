//
//  CommentTableViewCell.m
//  FTXClient
//
//  Created by Lei Perry on 6/27/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "UIColor+FTX.h"
#import "UIImageView+AFNetworking.h"

@implementation CommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.textLabel.textColor = [UIColor colorWithHex:0x1786af];
        
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:13];
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textColor = [UIColor colorWithHex:0xbbbbbb];
    }
    return self;
}

- (void)setReview:(Review *)review {
    _review = review;
    
    self.textLabel.text = [NSString stringWithFormat:@"%@：", review.reviewer.name];
    
    CGSize size = [self.textLabel.text sizeWithFont:self.textLabel.font];
    NSMutableString *prefix = [[NSMutableString alloc] init];
    while ([prefix sizeWithFont:[UIFont systemFontOfSize:13]].width <= size.width) {
        [prefix appendString:@" "];
    }
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@%@", prefix, review.content];
    self.detailTextLabel.hidden = YES;
    
    [self.imageView setImageWithURL:[NSURL URLWithString:review.reviewer.avatar] placeholderImage:[UIImage imageNamed:@"avatar-placeholder"]];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10, 10, 30, 30);
    
    CGSize size = [self.textLabel.text sizeWithFont:self.textLabel.font];
    self.textLabel.frame = CGRectMake(50, 10, 240, size.height);
    
    size = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font constrainedToSize:CGSizeMake(240, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    self.detailTextLabel.frame = CGRectMake(50, 10, 240, size.height);
}

+ (CGFloat)heightForCellWithReview:(Review *)review {
    CGSize size = [[NSString stringWithFormat:@"%@：", review.reviewer.name] sizeWithFont:[UIFont systemFontOfSize:13]];
    NSMutableString *prefix = [[NSMutableString alloc] init];
    while ([prefix sizeWithFont:[UIFont systemFontOfSize:13]].width <= size.width) {
        [prefix appendString:@" "];
    }
    size = [[NSString stringWithFormat:@"%@%@", prefix, review.content] sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(240, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    return fmaxf(50, size.height);
}

@end