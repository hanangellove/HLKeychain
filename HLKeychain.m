//
//  HLKeychain.m
//  testKeychain
//
//  Created by Mac on 15/7/7.
//  Copyright (c) 2015年 starFox. All rights reserved.
//

#import "HLKeychain.h"
static NSString * const KEY_USERNAME = @"com.yourapp.username";
static NSString * const KEY_PASSWORD = @"com.yourapp.password";

@implementation HLKeychain


+ (void)savePassword:(NSString *)password forServer:(NSString *)servername{
    NSMutableDictionary * userkeyChainPair = [NSMutableDictionary dictionary];
    [userkeyChainPair setObject:password forKey:KEY_PASSWORD];
    [self save:servername data:userkeyChainPair];
}

+ (NSString *)readPasswordForServer:(NSString *)servername{
    NSMutableDictionary * userKeychainPair = (NSMutableDictionary *)[self load:servername];
    return (NSString *)[userKeychainPair objectForKey:KEY_PASSWORD];
}
+ (void)deletePasswordForServer:(NSString *)servername{
    [self delete:servername];
    
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            service, (__bridge_transfer id)kSecAttrService,
            service, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
    
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
}
@end
