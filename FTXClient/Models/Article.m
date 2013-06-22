//
//  Article.m
//  FTXClient
//
//  Created by Lei Perry on 6/22/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "Article.h"

@implementation Article

- (id)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        
    }
    return self;
}

+ (void)retrieveArticlesWithBlock:(void (^)(NSArray *posts, NSError *error))block forCategory:(CategoryType)type atPage:(NSUInteger)pageIndex {
    
}

@end