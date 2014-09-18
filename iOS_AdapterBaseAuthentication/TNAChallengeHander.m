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
#import "TNAKeychain.h"

@interface TNAChallengeHander ()
@property (strong, nonatomic) AppDelegate *delegate;

@end

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
    self.delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    if ([responseJSON[@"authRequired"] intValue] == 1) {
        if ( ![responseJSON[@"errorMessage"] isKindOfClass:[NSNull class]] )
            [self.controller displayMessage:responseJSON[@"errorMessage"] withError:YES ];
        else {
            // If usr + pwd are existing, use passLock to do authentication in silence
            NSData *usr = [TNAKeychain loadValueForKey:NSLocalizedString(@"usr", nil)];
            NSData *pwd = [TNAKeychain loadValueForKey:NSLocalizedString(@"pwd", nil)];
            NSData *passLock = [TNAKeychain loadValueForKey:NSLocalizedString(@"passLock", nil)];
            
            if ( usr && pwd && passLock)
                [self.controller displayPassLock:nil];
            else {
                [self.controller showLoginForm];
            }
        }
    }
    else {
        
        // Save usr and pwd in keychain
        if (![TNAKeychain loadValueForKey:NSLocalizedString(@"usr", nil)] && ![TNAKeychain loadValueForKey:NSLocalizedString(@"pwd", nil)]) {
            [TNAKeychain saveValue:self.usr forKey:NSLocalizedString(@"usr",nil)];
            [TNAKeychain saveValue:self.pwd forKey:NSLocalizedString(@"pwd",nil)];
        }
        
        
        [self submitSuccess:response];
    }
}

#pragma mark - WLDelegate
-(void) onFailure:(WLFailResponse *)response {
    //NSLog(@"TNA3");
    [self submitFailure:response];
    [self.controller displayMessage:response.responseText withError:YES];
}
-(void) onSuccess:(WLResponse *)response {
    //NSLog(@"TNA4 %@",[response getResponseJson]);
    [self submitSuccess:response];
    NSString *message = [response getResponseJson][@"errorMessage"];
    [self.controller displayMessage:message withError:YES];
}




@end
