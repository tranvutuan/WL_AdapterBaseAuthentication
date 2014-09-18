//
//  TNAMonitor.h
//  iOS_MultiAdapterBasedAuthentication
//
//  Created by VuTuan Tran on 2014-09-16.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNAMonitor : NSObject
+(TNAMonitor*)sharedInstance;

@property (assign) NSInteger currAttempt;
@property (assign) NSInteger passLockMode;
@property (strong, nonatomic) NSMutableString *enteredPasscode;

-(void)validatePasscodeWithMessageType:(void(^)(int))completion;
-(void)storeInKeyChain:(NSString*)passLock withCompletion:(void(^)())completion;

@end
