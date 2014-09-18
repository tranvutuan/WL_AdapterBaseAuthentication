//
//  Constant.h
//  iOS_AdapterBaseAuthentication
//
//  Created by VuTuan Tran on 2014-09-18.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//
#define ScreenBound       ([[UIScreen mainScreen] bounds])
#define ScreenHeight      (ScreenBound.size.height)
#define ScreenWidth       (ScreenBound.size.width)

#define iPhoneType (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON) ? @"5" : ([UIScreen mainScreen].scale==2 || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"4" : @"3")

#ifndef iOS_AdapterBaseAuthentication_Constant_h
#define iOS_AdapterBaseAuthentication_Constant_h

#define capacity        4
#define MAX_ATTEMPTS    2
#define MAX_LENGTH      4

#define passLock_x      (ScreenWidth - 280)/2
#define passLockWith    280
#define passLockHeight  352

typedef enum {
    SubmitAuthenticationType = 0,
    FailureAttemptType = 1,
    FailureMessageType = 2,
    SuccessMessageType = 3,
    LogOutType = 4,
} AlertViewType;

typedef enum {
    KeychainNotExist = 0,
    KeychainExists = 1,
} PassLockMode;

#endif
