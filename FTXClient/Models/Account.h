//
//  Account.h
//  FTXClient
//
//  Created by Lei Perry on 7/1/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

@interface Account : NSObject

@property (readonly) NSString *accountId;
@property (readonly) NSString *nickName;
@property (readonly) NSString *password;
@property (readonly) NSUInteger userId;
@property (readonly) NSString *smallImageId;
@property (readonly) NSString *middleImageId;
@property (readonly) NSString *msg;
@property (readonly) NSUInteger sourceId;
@property (readonly) BOOL success;

@property NSString *avatarUrl;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end