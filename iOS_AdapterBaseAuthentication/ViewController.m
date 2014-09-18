//
//  ViewController.m
//  FormBaseAuthentication
//
//  Created by VuTuan Tran on 2014-09-05.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//
#import "Constant.h"
#import "TNAMonitor.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) AppDelegate *delegate;

@end

@implementation ViewController

#pragma mark - View cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"ViewTitle", nil);
    self.delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.delegate.challengeHandler.controller = self;
    
    self.passLock = [TNAPassLock loadPassLockView];
    self.passLock.delegate = self;
    self.passLock.frame = CGRectMake(passLock_x, -CGRectGetHeight(self.passLock.frame), passLockWith, passLockHeight);
    [self.view addSubview:self.passLock];
    
    /* Set awsome font for signOut button */
    id signOut = [NSString fontAwesomeIconStringForEnum:FASignOut];
    [self.signOut setTitle:[NSString stringWithFormat:@"%@", signOut] forState:UIControlStateNormal];
    self.signOut.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:30.f];
    
    /* Hide or show lock and unlock button */
    [self refreshUI];

    /* Register for challengeHanlder */
    [[WLClient sharedInstance] registerChallengeHandler:self.delegate.challengeHandler];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Check connection
- (IBAction)connectToServer:(id)sender {
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [[WLClient sharedInstance] invokeProcedure:delegate.getDataProcedureInvocation withDelegate:[[TNAInvokeListener alloc] initWithViewController:self]];
}

#pragma mark - UITextFieldDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
        case SubmitAuthenticationType: {
            if (buttonIndex == 1) {
                NSString *usr = [alertView textFieldAtIndex:0].text;
                NSString *pwd = [alertView textFieldAtIndex:1].text;
                
                AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                delegate.challengeHandler.usr = usr;
                delegate.challengeHandler.pwd = pwd;
                
                [delegate.submitAuthProcedureInvocation setParameters:[NSArray arrayWithObjects:usr,pwd, nil]];
                [delegate.challengeHandler submitAdapterAuthentication:delegate.submitAuthProcedureInvocation options:nil];
            }
            break;
        }
        case FailureAttemptType: {
            [TNAMonitor sharedInstance].currAttempt = 0;
            [self dismissPassLockWithOption:NO];
            break;
        }
        case FailureMessageType: {
            // Make sure enteredPasscode has something before deletion
            if ([TNAMonitor sharedInstance].enteredPasscode.length > 0 )
                [[TNAMonitor sharedInstance].enteredPasscode deleteCharactersInRange:NSMakeRange(0, 4)];
            break;
        }
        case SuccessMessageType : {
            // Make sure enteredPasscode has something before deletion
            if ([TNAMonitor sharedInstance].enteredPasscode.length > 0 )
                [[TNAMonitor sharedInstance].enteredPasscode deleteCharactersInRange:NSMakeRange(0, 4)];
            break;
        }
        case LogOutType: {
            [self dismissPassLockWithOption:NO];

        }
    }
}

#pragma mark - Show log in form
-(void)showLoginForm {
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"LogIn", nil)
                                                     message:NSLocalizedString(@"Enter Username & Password", nil)
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                           otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert addButtonWithTitle:NSLocalizedString(@"logIn", nil)];
    alert.tag = SubmitAuthenticationType;
    [alert show];

}

-(void)displayMessage:(NSString*)message withError:(BOOL)err {
    if (err) {
        if ([TNAMonitor sharedInstance].currAttempt < MAX_ATTEMPTS) { // Number of attempt is < 2
            [TNAMonitor sharedInstance].currAttempt++;
            [self showAlertViewWith:message andTag:FailureMessageType];
        }
        else {  // Number of attempt is > 3
            NSLog(@"SHOULD PROVIDE IMPLEMENTATION");
            [UIView animateWithDuration:.5
                             animations:^{
                                 self.passLock.frame = CGRectOffset(self.self.passLock.bounds, passLock_x,-CGRectGetHeight(self.passLock.frame));
                             }
                             completion:^(BOOL finished) {
                                 [TNAMonitor sharedInstance].currAttempt = 0;
                                 [[TNAMonitor sharedInstance].enteredPasscode deleteCharactersInRange:NSMakeRange(0, 4)];
                             }
             ];
        }
    }
    else {
        [UIView animateWithDuration:.5
                         animations:^{
                             self.passLock.frame = CGRectOffset(self.self.passLock.bounds, passLock_x,-CGRectGetHeight(self.passLock.frame));
                         }
                         completion:^(BOOL finished) {
                             [self showAlertViewWith:message andTag:SuccessMessageType];
                         }
         ];
        
    }
}

#pragma mark - WLDelegate
-(void)onSuccess:(WLResponse *)response {
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"Message",nil)
                                                     message:NSLocalizedString(@"Successfully to log out",nil)
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                           otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    alert.tag = LogOutType;
    [alert show];
}

-(void)onFailure:(WLFailResponse *)response {
    
}

#pragma mark - Log out
-(IBAction)logOut:(id)sender {
    [[WLClient sharedInstance] logout:NSLocalizedString(@"SingleStepAuthRealm", nil) withDelegate:self];
}

#pragma mark - Create pass lock
- (IBAction)displayPassLock:(id)sender {
    CGFloat new_y = 90;
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.passLock.frame = CGRectOffset(self.self.passLock.bounds, passLock_x,new_y);
                     }
                     completion:nil
     ];

}

#pragma mark - TNAPassLockDelegate - Dismiss pass lock
-(void)dismissPassLockWithOption:(BOOL)option {
    [UIView animateWithDuration:.5
                     animations:^{
                         self.passLock.frame = CGRectOffset(self.self.passLock.bounds, passLock_x,-CGRectGetHeight(self.passLock.frame));
                     }
                     completion:^(BOOL finished) {
                         if ([TNAMonitor sharedInstance].enteredPasscode.length > 0 )
                             [[TNAMonitor sharedInstance].enteredPasscode deleteCharactersInRange:NSMakeRange(0, [TNAMonitor sharedInstance].enteredPasscode.length)];
                         
                         [self refreshUI];
                     }
     ];
}

#pragma mark - Show alert view
-(void)showAlertViewWith:(NSString*)message andTag:(NSInteger)tag{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"Message", nil)
                                                     message:message
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                           otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    alert.tag = tag;
    [alert show];
}

#pragma mark - Helper : Remove all keychain
- (IBAction)deletePasslock:(id)sender {
    [TNAKeychain deleteValueForKey:@"usr"];
    [TNAKeychain deleteValueForKey:@"pwd"];
    [TNAKeychain deleteValueForKey:@"passLock"];
    
    /* Reset passLockMode to be not exist */
    [TNAMonitor sharedInstance].passLockMode = KeychainNotExist;
    [self refreshUI];
}

#pragma mark - Helper : Refresh UI
-(void)refreshUI {
    /* Set lock and unlock using Awsome font for buttons */
    if ([TNAMonitor sharedInstance].passLockMode == KeychainExists ) {
        id lockIcon  = [NSString fontAwesomeIconStringForEnum:FALock];
        self.passLockButton.hidden = YES;
        [self.lockButton setTitle:[NSString stringWithFormat:@"%@", lockIcon] forState:UIControlStateNormal];
        self.lockButton.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20.f];
    }
    else {
        id unLockIcon= [NSString fontAwesomeIconStringForEnum:FAUnlock];
        self.passLockButton.hidden = NO;
        [self.lockButton setTitle:[NSString stringWithFormat:@"%@", unLockIcon] forState:UIControlStateNormal];
        self.lockButton.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20.f];
    }
    self.removePassLockButton.hidden = !self.passLockButton.hidden;

}
@end
