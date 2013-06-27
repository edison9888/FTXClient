//
//  CommentTableViewCell.h
//  FTXClient
//
//  Created by Lei Perry on 6/27/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import "Review.h"

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic, strong) Review *review;

+ (CGFloat)heightForCellWithReview:(Review *)review;

@end