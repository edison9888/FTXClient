//
//  Author.m
//  FTXClient
//
//  Created by Lei Perry on 6/24/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "Author.h"

@implementation Author

- (id)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        _id = [attributes[@"authorId"] integerValue];
        _name = attributes[@"authorName"];
        _avatar = [NSString stringWithFormat:@"%@/%@", StagingBoxContentBase, attributes[@"authorImageId"]];
    }
    return self;
}

@end