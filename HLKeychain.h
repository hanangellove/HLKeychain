//
//  HLKeychain.h
//  testKeychain
//
//  Created by Mac on 15/7/7.
//  Copyright (c) 2015年 starFox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLKeychain : NSObject

+ (void)savePassword:(NSString *)password forServer:(NSString *)servername;
+ (NSString *)readPasswordForServer:(NSString *)servername;
+ (void)deletePasswordForServer:(NSString *)servername;
@end
