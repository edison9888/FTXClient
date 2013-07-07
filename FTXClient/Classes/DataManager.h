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
#import "Account.h"
#import "NetWorkReachability.h"

@interface DataManager : NSObject

@property (nonatomic, readonly) FMDatabase *db;
@property (nonatomic, strong) Account *currentAccount;
@property (nonatomic) NSUInteger categoryIndex;
@property (nonatomic, readonly) NSUInteger categoryTag;

+ (DataManager *)sharedManager;
- (void)checkDatabase;

- (void)cacheArticle:(Article *)article withTag:(NSUInteger)tag;
- (void)updateArticle:(Article *)article withKey:(NSString *)key andValue:(id)value;

- (void)loginVia:(LoginType)loginType withAccountId:(NSString *)accountId andPassword:(NSString *)password andNickName:(NSString *)nickName popViewController:(UIViewController *)controller;

@end