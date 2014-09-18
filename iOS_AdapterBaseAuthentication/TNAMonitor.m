//
//  TNAMonitor.m
//  iOS_MultiAdapterBasedAuthentication
//
//  Created by VuTuan Tran on 2014-09-16.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//
#import "Constant.h"
#import "TNAMonitor.h"
#import "AppDelegate.h"

static TNAMonitor *sharedInstance = nil;

@interface TNAMonitor ()
@property (strong, nonatomic) AppDelegate *delegate;

@end


@implementation TNAMonitor

#pragma mark - Get the shared instance and create it if necessary.
+ (TNAMonitor *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[TNAMonitor alloc] init];
    }
    
    return sharedInstance;
}

#pragma mark - regular init method
- (id)init {
    self = [super init];
    
    if (self) {
        self.currAttempt = 0;
        self.enteredPasscode = [[NSMutableString alloc] initWithCapacity:4];
    }
    
    return self;
}

#pragma mark - Store passlock into keychain
-(void)storeInKeyChain:(NSString*)passLock withCompletion:(void (^)())completion {
    [TNAKeychain saveValue:passLock forKey:NSLocalizedString(@"passLock",nil)];
    [TNAMonitor sharedInstance].passLockMode = KeychainExists;
    
    if (completion)
        completion();
}

#pragma mark - Validate pass lock
-(void)validatePasscodeWithMessageType:(void (^)(int type))completion {
    NSString *passFromKeyChain = [[NSString alloc] initWithData:[TNAKeychain loadValueForKey:NSLocalizedString(@"passLock", nil)] encoding:NSUTF8StringEncoding];
    
    if([self.enteredPasscode isEqual:passFromKeyChain]) {
        self.delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        NSString *usr = [[NSString alloc] initWithData:[TNAKeychain loadValueForKey:NSLocalizedString(@"usr", nil)] encoding:NSUTF8StringEncoding];
        NSString *pwd = [[NSString alloc] initWithData:[TNAKeychain loadValueForKey:NSLocalizedString(@"pwd", nil)] encoding:NSUTF8StringEncoding];
        
        [self.delegate.submitAuthProcedureInvocation setParameters:[NSArray arrayWithObjects:usr,pwd, nil]];
        [self.delegate.challengeHandler submitAdapterAuthentication:self.delegate.submitAuthProcedureInvocation options:nil];
    }
    else {
        if (self.currAttempt < MAX_ATTEMPTS) {
            self.currAttempt++;
            
            if (completion)
                completion(FailureMessageType);
            
        }
        else {
            if (completion)
                completion(FailureAttemptType);
        }
        
    }
        
}

@end
