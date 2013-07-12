//
//  Article.h
//  FTXClient
//
//  Created by Lei Perry on 6/22/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import "Author.h"
#import "FMResultSet.h"

@interface Article : NSObject

@property (readonly) NSUInteger id;
@property (readonly) NSUInteger type;
@property (readonly) NSString *title;
@property (readonly) NSString *summary;
@property (readonly) NSString *content;
@property (readonly) NSString *imageId;
@property (readonly) NSUInteger imageHeight;
@property (readonly) NSString *imageUrl;
@property (readonly) NSString *relevantIds;
@property (readonly) NSDate *publishTime;
@property (readonly) NSUInteger numOfRelevants;
@property (readwrite) NSUInteger numOfLikes;
@property (readwrite) NSUInteger numOfComments;
@property (readonly) NSString *sourceVideoUrl;
@property (readwrite) BOOL isLike;

@property (nonatomic, strong) UIImage *image;

@property (readonly) Author *author;

- (id)initWithAttributes:(NSDictionary *)attributes;
- (id)initWithResultSet:(FMResultSet *)rs;

@end