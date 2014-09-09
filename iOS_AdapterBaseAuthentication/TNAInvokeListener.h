//
//  TNAInvokeListener.h
//  FormBaseAuthentication
//
//  Created by VuTuan Tran on 2014-09-06.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//
#import "WLClient.h"
#import "WLDelegate.h"
#import <Foundation/Foundation.h>

@class ViewController;
@interface TNAInvokeListener : NSObject <WLDelegate>
@property (strong,nonatomic) ViewController *controller;
- (id)initWithViewController :(ViewController*)controller;
@end
