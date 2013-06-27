//
//  Article.h
//  FTXClient
//
//  Created by Lei Perry on 6/22/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import "Author.h"

@interface Article : NSObject

@property (readonly) NSUInteger id;
@property (readonly) NSUInteger type;
@property (readonly) NSString *title;
@property (readonly) NSString *summary;
@property (readonly) NSString *content;
@property (readonly) NSString *imageUrl;
@property (readonly) NSString *relevantIds;
@property (readonly) NSDate *publishTime;
@property (readonly) NSUInteger numOfRelevants;
@property (readonly) NSUInteger numOfLikes;
@property (readonly) NSUInteger numOfComments;

@property (nonatomic, strong) UIImage *image;

@property (readonly) Author *author;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)retrieveArticlesWithBlock:(void (^)(NSArray *articles, NSError *error))block forCategory:(CategoryType)type atPage:(NSUInteger)pageIndex;

@end