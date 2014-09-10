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
    //NSLog(@"TNA0 %@",[response getResponseJson]);
    NSDictionary *dict = [response getResponseJson];
    if (!response.responseText)
        return false;
    
	if (dict[@"authRequired"] != nil  )
		return true;
	else
		return false;
	
}

#pragma mark - Handle the challenge
-(void)handleChallenge: (WLResponse *)response {
    NSDictionary *responseJSON = [response getResponseJson];
    if ([responseJSON[@"authRequired"] intValue] == 1) {
        if ( ![responseJSON[@"errorMessage"] isKindOfClass:[NSNull class]] )
            [self.controller displayMessage:responseJSON[@"errorMessage"] ];
        else
            [self.controller showLoginForm];
    }
    else
        [self submitSuccess:response];
}

#pragma mark - WLDelegate
-(void) onFailure:(WLFailResponse *)response {
    //NSLog(@"TNA3");
    [self submitFailure:response];
    [self.controller displayMessage:response.responseText];
}
-(void) onSuccess:(WLResponse *)response {
    //NSLog(@"TNA4 %@",[response getResponseJson]);
    [self submitSuccess:response];
    NSString *message = [response getResponseJson][@"errorMessage"];
    [self.controller displayMessage:message];
}




@end
