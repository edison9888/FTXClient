//
//  Review.h
//  FTXClient
//
//  Created by Lei Perry on 6/27/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "Author.h"

@interface Review : NSObject

@property (readonly) NSUInteger id;
@property (readonly) NSUInteger articleId;
@property (readonly) NSString *content;
@property (readonly) NSDate *reviewTime;

@property (readonly) Author *author;
@property (readonly) Author *reviewer;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)retrieveReviewsWithBlock:(void (^)(NSArray *reviews, NSError *error))block withAuthodId:(NSUInteger)authorId andArticleId:(NSUInteger)artileId;

@end