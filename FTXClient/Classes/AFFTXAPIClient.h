//
//  AFAppDotNetAPIClient.h
//  FTXClient
//
//  Created by Lei Perry on 6/24/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "AFHTTPClient.h"

@interface AFFTXAPIClient : AFHTTPClient

+ (AFFTXAPIClient *)sharedClient;

@end