//
//  AFAppDotNetAPIClient.m
//  FTXClient
//
//  Created by Lei Perry on 6/24/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//

#import "AFJSONRequestOperation.h"

@implementation AFFTXAPIClient

+ (AFFTXAPIClient *)sharedClient {
    static AFFTXAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFFTXAPIClient alloc] initWithBaseURL:[NSURL URLWithString:StagingBoxInterfaceBase]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

@end