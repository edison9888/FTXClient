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

@interface CommentTableViewCell ()
{
    UILabel *_nameLabel;
}
@end

@implementation CommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor colorWithHex:0x444444];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = [UIColor colorWithHex:0x1786af];
        [self addSubview:_nameLabel];
        
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:13];
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textColor = [UIColor colorWithHex:0xbbbbbb];
    }
    return self;
}

- (void)setReview:(Review *)review {
    _review = review;
    
    _nameLabel.text = [NSString stringWithFormat:@"%@:", review.reviewer.name];
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@: %@", review.reviewer.name, review.content];
    
    [self.imageView setImageWithURL:[NSURL URLWithString:review.reviewer.avatar] placeholderImage:[UIImage imageNamed:@"avatar-placeholder"]];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(7, 7, 30, 30);
    
    CGSize size = [_nameLabel.text sizeWithFont:_nameLabel.font];
    _nameLabel.frame = CGRectMake(44, 7, size.width, size.height);
    
    size = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font constrainedToSize:CGSizeMake(240, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    self.detailTextLabel.frame = CGRectMake(44, 7, 249, size.height);
}

+ (CGFloat)heightForCellWithReview:(Review *)review {
    CGSize size = [[NSString stringWithFormat:@"%@: %@", review.reviewer.name, review.content] sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(249, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return fmaxf(44, size.height + 14);
}

@end