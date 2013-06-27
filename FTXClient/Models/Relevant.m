//
//  Relevant.m
//  FTXClient
//
//  Created by Lei Perry on 6/27/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "Relevant.h"
#import "AFFTXAPIClient.h"

@implementation Relevant

- (id)initWithAttributes:(NSDictionary *)attributes {
    
    if (self = [super init]) {
        _id = [attributes[@"id"] integerValue];
        _status = [attributes[@"status"] integerValue];
        _title = attributes[@"title"];
        _sourceUrl = attributes[@"sourceUrl"];
        _sourceType = [attributes[@"sourceType"] integerValue];
    }
    return self;
}

+ (void)retrieveRelevantsWithBlock:(void (^)(NSArray *relevants, NSError *error))block forIds:(NSString *)ids {
    [[AFFTXAPIClient sharedClient] getPath:[NSString stringWithFormat:@"/app/article/news?newIds=%@", ids]
                                parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id JSON) {
                                       NSArray *postsFromResponse = [JSON valueForKeyPath:@"news"];
                                       NSMutableArray *mutableRelevants = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
                                       for (NSDictionary *attributes in postsFromResponse) {
                                           Relevant *relevant = [[Relevant alloc] initWithAttributes:attributes];
                                           [mutableRelevants addObject:relevant];
                                       }
                                       
                                       if (block) {
                                           block([NSArray arrayWithArray:mutableRelevants], nil);
                                       }
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (block) {
                                           block([NSArray array], error);
                                       }
                                   }];
}

@end