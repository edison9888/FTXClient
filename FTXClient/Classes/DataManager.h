//
//  DataManager.h
//  FTXClient
//
//  Created by Lei Perry on 6/21/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "Article.h"

@interface DataManager : NSObject

@property (nonatomic, readonly) FMDatabase *db;

+ (DataManager *)sharedManager;
- (void)checkDatabase;

- (void)cacheArticle:(Article *)article;
- (void)updateArticle:(Article *)article withKey:(NSString *)key andValue:(id)value;

@end