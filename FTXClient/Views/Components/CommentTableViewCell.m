//
//  CommentTableViewCell.m
//  FTXClient
//
//  Created by Lei Perry on 6/27/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CommentTableViewCell.h"
#import "UIColor+FTX.h"
#import "UIImage+FTX.h"
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
    
    size = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font constrainedToSize:CGSizeMake(249, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    self.detailTextLabel.frame = CGRectMake(44, 7, 249, size.height);
}

+ (CGFloat)heightForCellWithReview:(Review *)review {
    CGSize size = [[NSString stringWithFormat:@"%@: %@", review.reviewer.name, review.content] sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(249, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return fmaxf(44, size.height + 14);
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
    [super willTransitionToState:state];
    
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask) {
        for (UIView *subview in self.subviews) {
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
                UIView *deleteButtonView = (UIView *)[subview.subviews objectAtIndex:0];
                
                UIView *overlay = [[UIView alloc] initWithFrame:deleteButtonView.bounds];
                overlay.backgroundColor = self.superview.backgroundColor;
                [deleteButtonView addSubview:overlay];
                
                CGRect rect = CGRectInset(deleteButtonView.bounds, 4, 2);
                rect.origin.x += 4;
                UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-delete-button"]];
                image.frame = rect;
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = rect;
                [button setBackgroundImage:[UIImage imageNamed:@"cell-delete-button"] forState:UIControlStateNormal];
                [deleteButtonView addSubview:button];
            }
        }
    }
    else if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateDefaultMask) {
        for (UIView *subview in self.subviews) {
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
                UIView *deleteButtonView = (UIView *)[subview.subviews objectAtIndex:0];
                for (int i=0; i<deleteButtonView.subviews.count; i++) {
                    UIButton *button = (UIButton *)deleteButtonView.subviews[i];
                    if ([button respondsToSelector:@selector(setBackgroundImage:forState:)])
                        [button setBackgroundImage:[UIImage imageNamed:@"cell-delete-button-selected"] forState:UIControlStateNormal];
                }
            }
        }
    }
}

@end