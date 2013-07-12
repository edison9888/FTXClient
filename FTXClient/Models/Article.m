//
//  Article.m
//  FTXClient
//
//  Created by Lei Perry on 6/22/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "Article.h"

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
        _relevantIds = attributes[@"newIds"];
        _imageId = attributes[@"imageId"];
        _imageHeight = [attributes[@"middleImageHeight"] integerValue];
        _numOfLikes = [attributes[@"likeCount"] integerValue];
        _numOfComments = [attributes[@"reviewCount"] integerValue];
        _numOfRelevants = [attributes[@"newsCnt"] integerValue];
        _sourceVideoUrl = attributes[@"sourceVideoUrl"];
        _isLike = [attributes[@"isLike"] boolValue];
        
        _author = [[Author alloc] initWithId:[attributes[@"authorId"] integerValue]
                                     andName:attributes[@"authorName"]
                                  andImageId:attributes[@"authorImageId"]];

        long long time = [attributes[@"publishTime"] longLongValue];
        _publishTime = [[NSDate alloc] initWithTimeIntervalSince1970:time/1000];
        
        _imageUrl = [NSString stringWithFormat:@"%@/%@", StagingBoxContentBase, _imageId];
    }
    return self;
}

- (id)initWithResultSet:(FMResultSet *)rs {
    if (self = [super init]) {
        if (nil == refFormatter) {
            refFormatter = [[NSDateFormatter alloc] init];
            refFormatter.dateFormat = @"yyyy-MM-dd";
            refFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        }
        
        _id = [rs intForColumn:@"id"];
        _type = [rs intForColumn:@"type"];
        _title = [rs stringForColumn:@"title"];
        _summary = [rs stringForColumn:@"summary"];
        _content = [rs stringForColumn:@"content"];
        _relevantIds = [rs stringForColumn:@"relevantIds"];
        _imageId = [rs stringForColumn:@"imageId"];
        _imageHeight = [rs intForColumn:@"imageHeight"];
        _numOfLikes = [rs intForColumn:@"numOfLikes"];
        _numOfComments = [rs intForColumn:@"numOfComments"];
        _numOfRelevants = [rs intForColumn:@"numOfRelevants"];
        _publishTime = [[NSDate alloc] initWithTimeIntervalSince1970:[rs intForColumn:@"publishTime"]];
        _sourceVideoUrl = [rs stringForColumn:@"videoUrl"];
        
        _author = [[Author alloc] initWithId:[rs intForColumn:@"authorId"]
                                     andName:[rs stringForColumn:@"authorName"]
                                  andImageId:[rs stringForColumn:@"authorImageId"]];
        
        // composite properties
        _imageUrl = [NSString stringWithFormat:@"%@/%@", StagingBoxContentBase, _imageId];
        NSString *docDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *imageFile = [docDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"images/%@", _imageId]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:imageFile]) {
            _image = [UIImage imageWithContentsOfFile:imageFile];
        }
    }
    return self;
}

@end