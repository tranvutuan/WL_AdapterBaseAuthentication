//
//  ViewController.h
//  FormBaseAuthentication
//
//  Created by VuTuan Tran on 2014-09-05.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNAInvokeListener.h"
#import "TNAChallengeHander.h"
#import "TNAConnectionListener.h"

typedef enum {
    Type1,
    Type2
} AlertViewType;

@interface ViewController : UIViewController <WLDelegate>
@property (strong, nonatomic) IBOutlet UIButton *connectingButton;
@property (strong, nonatomic) TNAInvokeListener *invokeLinster;
-(void)showLoginForm;
-(void)displaySecretData:(NSString*)secretData;
@end
