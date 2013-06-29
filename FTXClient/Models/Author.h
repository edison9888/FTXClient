//
//  Author.h
//  FTXClient
//
//  Created by Lei Perry on 6/24/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

@interface Author : NSObject

@property (readonly) NSUInteger id;
@property (readonly) NSString *name;
@property (readonly) NSString *imageId;
@property (readonly) NSString *avatar;

- (id)initWithId:(NSUInteger)id andName:(NSString *)name andImageId:(NSString *)imageId;

@end