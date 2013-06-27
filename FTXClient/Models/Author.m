//
//  Author.m
//  FTXClient
//
//  Created by Lei Perry on 6/24/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "Author.h"

@implementation Author

- (id)initWithId:(NSUInteger)id andName:(NSString *)name andImageId:(NSString *)imageId {
    if (self = [super init]) {
        _id = id;
        _name = name;
        _avatar = [NSString stringWithFormat:@"%@/%@", StagingBoxContentBase, imageId];
    }
    return self;
}

@end