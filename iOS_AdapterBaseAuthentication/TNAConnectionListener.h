//
//  TNAConnection.h
//  FormBaseAuthentication
//
//  Created by VuTuan Tran on 2014-09-06.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//
#import "WLClient.h"
#import "WLDelegate.h"
//#import "ViewController.h"
#import "TNAInvokeListener.h"
#import "TNAChallengeHander.h"
#import <Foundation/Foundation.h>


@class ViewController;
@interface TNAConnectionListener : NSObject <WLDelegate>

@property (strong,nonatomic) ViewController *controller;
- (id)initWithViewController :(ViewController*)controller;
@end
