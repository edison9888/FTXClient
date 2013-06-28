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

@interface DataManager : NSObject

@property (nonatomic, readonly) FMDatabase *db;
@property (nonatomic, readonly) FMDatabaseQueue *dbQueue;

+ (DataManager *)sharedManager;
- (void)checkDatabase;

@end