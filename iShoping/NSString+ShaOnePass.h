//
//  NSString+ShaOnePass.h
//  iShoping
//
//  Created by SHENFENG125 on 14-4-21.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
@interface NSString (ShaOnePass)
- (NSString*)sha1:(NSString*)string;
@end
