//
//  Account.m
//  FTXClient
//
//  Created by Lei Perry on 7/1/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "Account.h"

@implementation Account

- (id)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        _accountId = attributes[@"accountId"];
        _nickName = attributes[@"nickName"];
        _password = attributes[@"password"];
        _userId = [attributes[@"userId"] integerValue];
        _smallImageId = attributes[@"smallImageId"];
        _middleImageId = attributes[@"middleImageId"];
        _msg = attributes[@"msg"];
        _sourceId = [attributes[@"sourceId"] integerValue];
        _success = [attributes[@"success"] boolValue];
        
        _avatarUrl = [NSString stringWithFormat:@"%@/%@", StagingBoxContentBase, _middleImageId];
    }
    return self;
}

@end