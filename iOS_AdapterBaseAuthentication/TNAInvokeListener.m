//
//  TNAInvokeListener.m
//  FormBaseAuthentication
//
//  Created by VuTuan Tran on 2014-09-06.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//
#import "ViewController.h"
#import "TNAInvokeListener.h"
@implementation TNAInvokeListener

#pragma mark - Initalization
- (id)initWithViewController :(ViewController*)controller;{
    if ( self = [super init] )
        self.controller = controller;
    return self;
}

#pragma mark - WLDelegate
-(void)onSuccess:(WLResponse *)response {
    //NSLog(@"TNA1 %@",[response getResponseJson]);

    NSString *secretData = [response getResponseJson][@"secretData"];
    NSString *errorMessage = [response getResponseJson][@"errorMessage"];

    [self.controller displayMessage:secretData ? secretData : errorMessage];

}
-(void)onFailure:(WLFailResponse *)response {
    //NSLog(@"TNA2");
}
@end
