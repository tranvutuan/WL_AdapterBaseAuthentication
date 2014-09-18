//
//  TNAPassLockView.h
//  iOS_MultiAdapterBasedAuthentication
//
//  Created by VuTuan Tran on 2014-09-16.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//
#import "TNAMonitor.h"
#import "TNAKeychain.h"
#import <UIKit/UIKit.h>

@protocol TNAPassLockDelegate <NSObject>
-(void)dismissPassLockWithOption:(BOOL)option;
-(void)showAlertViewWith:(NSString*)message andTag:(NSInteger)tag;
@end

@interface TNAPassLock : UIView
@property(assign) id<TNAPassLockDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *codeLabel;

+(id)loadPassLockView;

@end
