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

static NSDateFormatter* refFormatter = nil;

- (id)initWithAttributes:(NSDictionary *)attributes {
    
    if (self = [super init]) {
        if (nil == refFormatter) {
            refFormatter = [[NSDateFormatter alloc] init];
            refFormatter.dateFormat = @"yyyy-MM-dd";
            refFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        }
        
        _id = [attributes[@"id"] integerValue];
        _type = [attributes[@"type"] integerValue];
        _title = attributes[@"title"];
        _summary = attributes[@"summary"];
        _content = attributes[@"content"];
        _imageUrl = [NSString stringWithFormat:@"%@/%@", StagingBoxContentBase, attributes[@"imageId"]];
        _numOfLikes = [attributes[@"likeCount"] integerValue];
        _numOfComments = [attributes[@"reviewCount"] integerValue];
        _numOfRelevants = [attributes[@"newsCnt"] integerValue];
        
        _author = [[Author alloc] initWithId:[attributes[@"authorId"] integerValue]
                                     andName:attributes[@"authorName"]
                                  andImageId:attributes[@"authorImageId"]];

        long long time = [attributes[@"publishTime"] longLongValue];
        _publishTime = [[NSDate alloc] initWithTimeIntervalSince1970:time/1000];
    }
    return self;
}

+ (void)retrieveArticlesWithBlock:(void (^)(NSArray *articles, NSError *error))block forCategory:(CategoryType)type atPage:(NSUInteger)pageIndex {
    [[AFFTXAPIClient sharedClient] getPath:[NSString stringWithFormat:@"/app/article/list?pageNo=%d", pageIndex]
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