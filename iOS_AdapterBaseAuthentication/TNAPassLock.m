//
//  TNAPassLockView.m
//  iOS_MultiAdapterBasedAuthentication
//
//  Created by VuTuan Tran on 2014-09-16.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//

#import "Constant.h"
#import "TNAPassLock.h"
#import "ViewController.h"

@interface TNAPassLock ()
@property (strong, nonatomic) NSMutableString *asterisk;

@end

@implementation TNAPassLock

#pragma mark - 
+ (id)loadPassLockView {
    TNAPassLock *passLock = [[[NSBundle mainBundle] loadNibNamed:@"TNAPassLock" owner:nil options:nil] lastObject];
    
    // make sure customView is not nil or the wrong class!
    if ([passLock isKindOfClass:[TNAPassLock class]])
        return passLock;
    else
        return nil;
}

#pragma mark - Regular init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Corner rounding
-(void)layoutSubviews {
    [super layoutSubviews];
    for (NSInteger tag = 0; tag <= 9; tag++) {
        if ( [[self viewWithTag:tag] isKindOfClass:[UIButton class]] ) {
            UIButton *button = (UIButton*)[self viewWithTag:tag];
            [button setBackgroundColor:[UIColor clearColor]];
            [[button layer] setBorderColor:[UIColor whiteColor].CGColor];
            [[button layer] setBorderWidth:1.0f];
            CGFloat radius = button.frame.size.width / 2;
            [[button layer] setCornerRadius:radius];
        }
    }
}

#pragma mark - Pin enterted
- (IBAction)pinEntered:(id)sender {
    [[TNAMonitor sharedInstance].enteredPasscode appendString:((UIButton*)sender).currentTitle];
    
    /* Initialize asterisk */
    if ( !self.asterisk )
        self.asterisk = [[NSMutableString alloc] initWithCapacity:capacity];
    
    /* Show asterisk as FACamera */
    id lockIcon  = [NSString fontAwesomeIconStringForEnum:FACertificate];

    self.codeLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:30.f];
    [self.asterisk appendString:[NSString stringWithFormat:@"%@", lockIcon]];
    self.codeLabel.text = self.asterisk;
    
    /* Whether we store (not exist) or validate the passcode ( if it exists) */
    if ([TNAMonitor sharedInstance].enteredPasscode.length == MAX_LENGTH) {
        if ([TNAMonitor sharedInstance].passLockMode == KeychainNotExist) {
            [[TNAMonitor sharedInstance] storeInKeyChain:[TNAMonitor sharedInstance].enteredPasscode
                                          withCompletion:^{
                                              /* Reset asterisk */
                                              if (self.asterisk.length > 0 ) {
                                                  [self.asterisk deleteCharactersInRange:NSMakeRange(0, self.asterisk.length)];
                                                  self.codeLabel.text = NSLocalizedString(@" Enter pass code", nil);
                                              }

                                              [self.delegate dismissPassLockWithOption:YES];
                                          }
             ];
        }
        else {
            self.codeLabel.text = NSLocalizedString(@" Enter pass code", nil);
            [self.asterisk deleteCharactersInRange:NSMakeRange(0, MAX_LENGTH)];
            [[TNAMonitor sharedInstance] validatePasscodeWithMessageType:^(int type) {
                [self.delegate showAlertViewWith:NSLocalizedString(@"Invalid pass lock", nil) andTag:type];
            }];           
        }
    }
}

#pragma mark - Pin erased
- (IBAction)pinErased:(id)sender {
    if ([[TNAMonitor sharedInstance].enteredPasscode length] > 0) {
        NSInteger location = [TNAMonitor sharedInstance].enteredPasscode.length - 1;
        [self.asterisk deleteCharactersInRange:NSMakeRange(location, 1)];
        self.codeLabel.text = self.asterisk;
        [[TNAMonitor sharedInstance].enteredPasscode deleteCharactersInRange:NSMakeRange(location, 1)];
        if ( self.asterisk.length == 0 ) {
            self.codeLabel.text = NSLocalizedString(@" Enter pass code", nil);
        }
    }
}

#pragma mark - Cancel
-(IBAction)cancelPassCode:(id)sender {
    self.codeLabel.text = NSLocalizedString(@" Enter pass code", nil);
    /* Reset asterisk */
    if (self.asterisk.length > 0 ) {
        [self.asterisk deleteCharactersInRange:NSMakeRange(0, self.asterisk.length)];
        self.codeLabel.text = NSLocalizedString(@" Enter pass code", nil);
    }
    [self.delegate dismissPassLockWithOption:YES];
}
@end


