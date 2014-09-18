//
//  TNAKeychain.m
//  iOS_AdapterBaseAuthentication
//
//  Created by VuTuan Tran on 2014-09-17.
//  Copyright (c) 2014 dhltd.apple. All rights reserved.
//

#import "TNAKeychain.h"

@interface TNAKeychain ()

+ (NSMutableDictionary *)getKeychainDictForKey:(NSString *)key;

@end

@implementation TNAKeychain


+ (NSMutableDictionary *)getKeychainDictForKey:(NSString *)key
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:encodedKey forKey:(__bridge id)kSecAttrGeneric];
    [dict setObject:encodedKey forKey:(__bridge id)kSecAttrAccount];
    [dict setObject:key forKey:(__bridge id)kSecAttrService];
    //[dict setObject:(__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];

    
    return  dict;
}

+(void)saveValue:(NSString*)value forKey:(NSString*)key
{
    NSMutableDictionary *keychainQuery = [self getKeychainDictForKey:key];
    
    NSData * data = [value dataUsingEncoding:NSUTF8StringEncoding];
    
    // Delete any previous value with this key
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
    [keychainQuery setObject:data forKey:(__bridge id)kSecValueData];
    
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+(NSData*)loadValueForKey:(NSString *)key {
    NSMutableDictionary *dict = [self getKeychainDictForKey:key];
    [dict setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [dict setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)dict,&result);
    
    if( status != errSecSuccess)
        return nil;
    
    return (__bridge NSData *)result;
}

+ (void)deleteValueForKey:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self getKeychainDictForKey:key];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

@end