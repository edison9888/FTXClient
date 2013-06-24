//
//  Article.m
//  FTXClient
//
//  Created by Lei Perry on 6/22/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "Article.h"
#import "AFFTXAPIClient.h"

@implementation Article

- (id)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        _id = [attributes[@"id"] integerValue];
        _type = [attributes[@"type"] integerValue];
        _title = attributes[@"title"];
        _summary = attributes[@"summary"];
        _content = attributes[@"content"];
        _image = [NSString stringWithFormat:@"%@/%@", StagingBoxContentBase, attributes[@"imageId"]];
        _publishTime = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:[attributes[@"publishTime"] integerValue]];
        
        _author = [[Author alloc] initWithAttributes:attributes];
    }
    return self;
}

+ (void)retrieveArticlesWithBlock:(void (^)(NSArray *articles, NSError *error))block forCategory:(CategoryType)type atPage:(NSUInteger)pageIndex {
    [[AFFTXAPIClient sharedClient] getPath:@"/app/article/list"
                                parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id JSON) {
                                       NSArray *postsFromResponse = [JSON valueForKeyPath:@"articles"];
                                       NSMutableArray *mutableArticles = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
                                       for (NSDictionary *attributes in postsFromResponse) {
                                           Article *article = [[Article alloc] initWithAttributes:attributes];
                                           [mutableArticles addObject:article];
                                       }
                                       
                                       if (block) {
                                           block([NSArray arrayWithArray:mutableArticles], nil);
                                       }
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (block) {
                                           block([NSArray array], error);
                                       }
                                   }];
}

@end