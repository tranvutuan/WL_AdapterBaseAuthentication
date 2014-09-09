//
//  TNAChallengeHander.m
//  FormBaseAuthentication
//
//  Created by VuTuan Tran on 2014-09-06.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//
#import "TNAConnectionListener.h"
#import "TNAChallengeHander.h"
#import "AppDelegate.h"
@implementation TNAChallengeHander


#pragma mark -  Test whether there is a custom challenge to be handled in the response
-(BOOL)isCustomResponse:(WLResponse *)response {
    NSLog(@"TNA0");
    NSDictionary *dict = [response getResponseJson];
    if (!response.responseText)
        return false;
    
	if (dict[@"authRequired"] != nil && [dict[@"authRequired"] integerValue] == 0 )
//    if (dict[@"authRequired"] && [dict[@"authRequired"] integerValue])
		return true;
	else
		return false;
	
}

#pragma mark - Handle the challenge
-(void)handleChallenge: (WLResponse *)response {
    NSLog(@"TNA8");
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [[WLClient sharedInstance] invokeProcedure:delegate.getDataProcedureInvocation withDelegate:[[TNAInvokeListener alloc] initWithViewController:self.controller]];
}

#pragma mark - WLDelegate
-(void) onFailure:(WLFailResponse *)response {
    NSLog(@"TNA3");
    [self submitFailure:response];
    [self.controller displaySecretData:response.responseText];
}
-(void) onSuccess:(WLResponse *)response {
    [self submitSuccess:response];
    NSString *message = [response getResponseJson][@"errorMessage"];
    [self.controller displaySecretData:message];
    NSLog(@"TNA4");
}




@end
