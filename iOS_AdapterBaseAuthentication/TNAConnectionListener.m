//
//  TNAConnection.m
//  FormBaseAuthentication
//
//  Created by VuTuan Tran on 2014-09-06.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//
#import "AppDelegate.h"
#import "ViewController.h"
#import "WLChallengeHandler.h"
#import "TNAConnectionListener.h"

@interface TNAConnectionListener ()

@end

@implementation TNAConnectionListener

#pragma mark - Initalization
- (id)initWithViewController :(ViewController*)controller;{
    if ( self = [super init] )
        self.controller = controller;
    return self;
}

#pragma mark - WLDelegate
-(void)onSuccess:(WLResponse *)response {
    //NSLog(@"TNA5");

    NSDictionary *dict = [response getResponseJson];
    BOOL isUseAuthenticated = [dict[@"userInfo"][@"SingleStepAuthRealm"][@"isUserAuthenticated"] integerValue];
    if (!isUseAuthenticated )
        [self.controller showLoginForm];
    else {
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [[WLClient sharedInstance] invokeProcedure:delegate.getDataProcedureInvocation withDelegate:[[TNAInvokeListener alloc] initWithViewController:self.controller]];
    }
}
-(void)onFailure:(WLFailResponse *)response {
    NSLog(@"%s",__func__);

}
@end
