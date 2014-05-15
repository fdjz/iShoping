//
//  NSString+ShaOnePass.m
//  iShoping
//
//  Created by SHENFENG125 on 14-4-21.
//  Copyright (c) 2014年 Cuwoyinyue. All rights reserved.
//

#import "NSString+ShaOnePass.h"

@implementation NSString (ShaOnePass)
- (NSString*)sha1:(NSString*)string;
{
    //    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}
@end
