//
//  ViewController.h
//  FormBaseAuthentication
//
//  Created by VuTuan Tran on 2014-09-05.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//
#import "TNAPassLock.h"
#import <UIKit/UIKit.h>
#import "TNAInvokeListener.h"
#import "TNAChallengeHander.h"
#import "NSString+FontAwesome.h"
#import "TNAConnectionListener.h"


@interface ViewController : UIViewController <WLDelegate,TNAPassLockDelegate>
@property (strong, nonatomic) TNAPassLock *passLock;
@property (strong, nonatomic) IBOutlet UIButton *connectingButton;
@property (strong, nonatomic) TNAInvokeListener *invokeLinster;
@property (strong, nonatomic) IBOutlet UIButton *passLockButton;
@property (strong, nonatomic) IBOutlet UIButton *removePassLockButton;
@property (strong, nonatomic) IBOutlet UIButton *lockButton;

@property (strong, nonatomic) IBOutlet UIButton *signOut;
-(void)showLoginForm;
- (IBAction)displayPassLock:(id)sender;
-(void)displayMessage:(NSString*)message withError:(BOOL)err;
@end
