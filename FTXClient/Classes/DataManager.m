//
//  DataManager.m
//  FTXClient
//
//  Created by Lei Perry on 6/21/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "FMResultSet.h"
#import "UMSocial.h"

#define MAX_RECORDS_PER_TAG 100

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
        NSString *docDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [docDirectory stringByAppendingPathComponent:@"cache"];
        _dbPath = [path stringByAppendingString: @".db"];
        
        // create images folder if not exists
        NSString *imagesFolder = [docDirectory stringByAppendingPathComponent:@"images"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:imagesFolder]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:imagesFolder
                                      withIntermediateDirectories:NO
                                                       attributes:nil
                                                            error:nil];
        }
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

- (void)setCurrentAccount:(Account *)currentAccount {
    _currentAccount = currentAccount;
    [[NSNotificationCenter defaultCenter] postNotificationName:kAccountChangeNotification object:self];
}

- (void)setCategoryIndex:(NSUInteger)categoryIndex {
    if (_categoryIndex != categoryIndex) {
        _categoryIndex = categoryIndex;
        [[NSNotificationCenter defaultCenter] postNotificationName:kCategoryIndexChangeNotification object:self];
    }
}

static NSArray *tags;
- (NSUInteger)categoryTag {
    if (tags == nil)
        tags = @[@0, @(CategoryTypeBasketball), @(CategoryTypeFootball), @(CategoryTypeFun),  @(CategoryTypeVideo)];
    return [tags[_categoryIndex] integerValue];
}

- (void)cacheArticle:(Article *)article withTag:(NSUInteger)tag {
    NSUInteger count = [_db intForQuery:@"SELECT COUNT(*) FROM Article WHERE id = ?", @(article.id)];
    if (count == 0) {
        NSString *q = @"INSERT INTO Article (id, type, title, summary, content, imageId, imageHeight, relevantIds, publishTime, numOfRelevants, numOfLikes, numOfComments, authorId, authorName, authorImageId, videoUrl) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        [_db executeUpdate:q, @(article.id), @(article.type), article.title, article.summary, article.content, article.imageId, @(article.imageHeight), article.relevantIds, @([article.publishTime timeIntervalSince1970]), @(article.numOfRelevants), @(article.numOfLikes), @(article.numOfComments), @(article.author.id), article.author.name, article.author.imageId, article.sourceVideoUrl];
    }
    else {
        NSString *q = @"UPDATE Article SET numOfLikes = ?, numOfComments = ? WHERE ID = ?";
        [_db executeUpdate:q, @(article.numOfLikes), @(article.numOfComments), @(article.id)];
    }
    
    count = [_db intForQuery:@"SELECT COUNT(*) FROM Article_Tag WHERE articleId = ? AND tag = ?", @(article.id), @(tag)];
    if (count == 0) {
        NSString *q = @"INSERT INTO Article_Tag (articleId, tag) VALUES (?, ?)";
        [_db executeUpdate:q, @(article.id), @(tag)];
        
        count = [_db intForQuery:@"SELECT COUNT(*) FROM Article_Tag WHERE tag = ?", @(tag)];
        if (count > MAX_RECORDS_PER_TAG) {
            [_db executeUpdate:@"DELETE FROM Article_Tag WHERE articleId = (SELECT MIN(articleId) FROM Article_Tag WHERE tag = ?)", @(tag)];
        }
    }
}

- (void)updateArticle:(Article *)article withKey:(NSString *)key andValue:(id)value {
    NSString *query = [NSString stringWithFormat:@"UPDATE Article SET %@ = ? WHERE id = ?", key];
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (![db executeUpdate:query, value, article.id])
            DLog(@"update article(%d) with key(%@) and value(%@) failed", article.id, key, value);
    }];
}

- (void)loginVia:(LoginType)loginType withAccountId:(NSString *)accountId andPassword:(NSString *)password andNickName:(NSString *)nickName popViewController:(UIViewController *)controller {
    if ([NetworkReachability sharedReachability].reachable) {
        [[AFFTXAPIClient sharedClient] getPath:[NSString stringWithFormat:@"/app/user/login?accountId=%@&nickName=%@&password=%@&sourceId=%d", accountId, nickName, password, loginType]
                                    parameters:nil
                                       success:^(AFHTTPRequestOperation *operation, id JSON) {
//                                           DLog(@"success: %@", JSON);
                                           Account *account = [[Account alloc] initWithAttributes:JSON];
                                           if (!account.success) {
                                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:account.msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                               [alert show];
                                           }
                                           else {
                                               LoginType loginType = [[JSON objectForKey:@"sourceId"] integerValue];
                                               if (loginType == LoginTypeSina) {
                                                   NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
                                                   UMSocialAccountEntity *snsAccount = [snsAccountDic valueForKey:UMShareToSina];
                                                   account.avatarUrl = snsAccount.iconURL;
                                               }
                                               else if (loginType == LoginTypeTencent) {
                                                   NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
                                                   UMSocialAccountEntity *snsAccount = [snsAccountDic valueForKey:UMShareToQzone];
                                                   account.avatarUrl = snsAccount.iconURL;
                                               }
                                               
                                               
                                               [UserDefaults setValue:accountId forKey:kUCLoginAccountId];
                                               [UserDefaults setValue:password forKey:kUCLoginPassword];
                                               [UserDefaults setInteger:loginType forKey:kUCLoginType];
                                               [UserDefaults synchronize];
                                               
                                               self.currentAccount = account;
                                               if (controller)
                                                   [controller.navigationController popViewControllerAnimated:YES];
                                           }
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           DLog(@"error: %@", [error description]);
                                       }];
    }
}

@end