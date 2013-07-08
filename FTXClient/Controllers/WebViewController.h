//
//  WebViewController.h
//  FTXClient
//
//  Created by Lei Perry on 6/28/13.
//  Copyright (c) 2013 BitRice. All rights reserved.
//
#import "Relevant.h"

@interface WebViewController : UIViewController<UIWebViewDelegate>

- (id)initWithRelevant:(Relevant *)relevant;

@end