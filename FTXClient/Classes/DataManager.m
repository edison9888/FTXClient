//
//  DataManager.m
//  FTXClient
//
//  Created by Lei Perry on 6/21/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "DataManager.h"
#import "FMResultSet.h"

@interface DataManager ()

@property (readonly) NSString *dbPath;
@property (nonatomic, readonly) FMDatabaseQueue *dbQueue;

@end

@implementation DataManager

+ (DataManager *)sharedManager {
    static DataManager* _instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[DataManager alloc] init];
    });
    return _instance;
}

- (id)init {
    if (self = [super init]) {
        // get db path
        NSString *appDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [appDirectory stringByAppendingPathComponent:@"cache"];
        _dbPath = [path stringByAppendingString: @".db"];
        
    }
    return self;
}

- (void)checkDatabase {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if (![fileManager fileExistsAtPath:self.dbPath])
    {
        NSString *file = [[NSBundle bundleForClass:[self class]] pathForResource:@"cache.db" ofType:nil];
        DLog(@"bundle db file: %@",file);
        NSError *error;
        if (![fileManager copyItemAtPath:file toPath:self.dbPath error:&error])
            DLog(@"Error copying database to document: %@", [error description]);
    }
    else {
        // TODO: upgrade?
    }
    
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    _db = [FMDatabase databaseWithPath:_dbPath];
    [_db open];
}

- (void)cacheArticle:(Article *)article {
    __block Article *art = article;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            FMResultSet *rs = [db executeQuery:@"SELECT * FROM Article WHERE id = ?", @(art.id)];
            if (![rs next]) {
                NSString *q = @"INSERT INTO Article (id, type, title, summary, content, imageId, imageHeight, relevantIds, publishTime, numOfRelevants, numOfLikes, numOfComments, authorId, authorName, authorImageId, videoUrl) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                [db executeUpdate:q, @(art.id), @(art.type), art.title, art.summary, art.content, art.imageId, @(art.imageHeight), art.relevantIds, @([art.publishTime timeIntervalSince1970]), @(art.numOfRelevants), @(art.numOfLikes), @(art.numOfComments), @(art.author.id), art.author.name, art.author.imageId, art.videoUrl];
            }
        }];
    });
}

- (void)updateArticle:(Article *)article withKey:(NSString *)key andValue:(id)value {
    NSString *query = [NSString stringWithFormat:@"UPDATE Article SET %@ = ? WHERE id = ?", key];
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (![db executeUpdate:query, value, article.id])
            DLog(@"update article(%d) with key(%@) and value(%@) failed", article.id, key, value);
    }];
}

@end