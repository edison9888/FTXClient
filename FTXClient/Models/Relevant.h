//
//  Relevant.h
//  FTXClient
//
//  Created by Lei Perry on 6/27/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

@interface Relevant : NSObject

@property (readonly) NSUInteger id;
@property (readonly) NSUInteger status;
@property (readonly) NSString *title;
@property (readonly) NSString *sourceUrl;
@property (readonly) NSUInteger sourceType;
@property (readonly) NSString *sourceTypeName;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)retrieveRelevantsWithBlock:(void (^)(NSArray *relevants, NSError *error))block forIds:(NSString *)ids;

@end