//
//  Article.h
//  FTXClient
//
//  Created by Lei Perry on 6/22/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

@interface Article : NSObject

@property (readonly) NSUInteger id;
@property (readonly) NSUInteger type;
@property (readonly) NSUInteger authorId;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)retrieveArticlesWithBlock:(void (^)(NSArray *posts, NSError *error))block forCategory:(CategoryType)type atPage:(NSUInteger)pageIndex;

@end