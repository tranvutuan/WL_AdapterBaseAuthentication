//
//  TNAKeychain.h
//  iOS_AdapterBaseAuthentication
//
//  Created by VuTuan Tran on 2014-09-17.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNAKeychain : NSObject
+(void)saveValue:(NSString*)data forKey:(NSString*)key;
+(NSData*)loadValueForKey:(NSString*)key;
+(void)deleteValueForKey:(NSString *)key;

+(NSString *)securedSHA256ForPIN:(NSUInteger)pinHash;
+(NSString*)computeSHA256DigestForString:(NSString*)input;
@end
