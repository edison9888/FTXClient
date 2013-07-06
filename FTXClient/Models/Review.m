//
//  Review.m
//  FTXClient
//
//  Created by Lei Perry on 6/27/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "Review.h"
#import "GTMNSString+HTML.h"

@implementation Review

static NSDateFormatter* refFormatter = nil;

- (id)initWithAttributes:(NSDictionary *)attributes {
    
    if (self = [super init]) {
        if (nil == refFormatter) {
            refFormatter = [[NSDateFormatter alloc] init];
            refFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            refFormatter.locale = [NSLocale currentLocale];
        }
        
        _id = [attributes[@"id"] integerValue];
        _articleId = [attributes[@"articleId"] integerValue];
        _content = attributes[@"content"];
        _content = [_content stringByStrippingHTML];
        
        _author = [[Author alloc] initWithId:[attributes[@"authorId"] integerValue]
                                     andName:attributes[@"authorName"]
                                  andImageId:attributes[@"authorImageId"]];
        _reviewer = [[Author alloc] initWithId:[attributes[@"reviewerId"] integerValue]
                                     andName:attributes[@"reviewerName"]
                                  andImageId:attributes[@"reviewerImageId"]];
        
        long long time = [attributes[@"reviewTime"] longLongValue];
        _reviewTime = [[NSDate alloc] initWithTimeIntervalSince1970:time/1000];
    }
    return self;
}

+ (void)retrieveReviewsWithBlock:(void (^)(NSArray *, NSError *))block withAuthodId:(NSUInteger)authorId andArticleId:(NSUInteger)artileId {
    [[AFFTXAPIClient sharedClient] getPath:[NSString stringWithFormat:@"/res/article/more_review?author_id=%d&article_id=%d", authorId, artileId]
                                parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id JSON) {
                                       NSArray *postsFromResponse = [JSON valueForKeyPath:@"reviewList"];
                                       NSMutableArray *mutableReviews = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
                                       for (NSDictionary *attributes in postsFromResponse) {
                                           Review *review = [[Review alloc] initWithAttributes:attributes];
                                           [mutableReviews addObject:review];
                                       }
                                       
                                       if (block) {
                                           block([NSArray arrayWithArray:mutableReviews], nil);
                                       }
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (block) {
                                           block([NSArray array], error);
                                       }
                                   }];
}

@end