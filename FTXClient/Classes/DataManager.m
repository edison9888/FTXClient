//
//  DataManager.m
//  FTXClient
//
//  Created by Lei Perry on 6/21/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "DataManager.h"
@interface DataManager ()

@property (readonly) NSString *dbPath;

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
}

@end