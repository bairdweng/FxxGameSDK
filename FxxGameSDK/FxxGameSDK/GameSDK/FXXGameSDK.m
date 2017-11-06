//
//  FXXGameSDK.m
//  CSGameMb
//
//  Created by Baird-weng on 2017/11/4.
//  Copyright © 2017年 Baird-weng. All rights reserved.
//

#import "FXXGameSDK.h"
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import "FYNetworking.h"
#define FXXGAMEURL @"https://123.207.47.17/xgg/regisdevicebygame"
@implementation FXXGameSDK
+(instancetype)sharedManager{
    static FXXGameSDK* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
- (void)registeredWithNeedURL:(BOOL)isNeedURL withResultBlock:(resultBlock)block{
    NSDictionary* infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *displayName = [infoDic objectForKey:@"CFBundleDisplayName"];
    NSString* bundleIdentifier = [infoDic objectForKey:@"CFBundleIdentifier"];
    if (!displayName||!bundleIdentifier) {
        [self showErrorWithString:@"请填写应用名称和套装id"];
        return;
    }
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"appName" : displayName,
        @"bundleIdentifier" : bundleIdentifier,
        @"idfa" : [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]
    }];
    if (isNeedURL == YES) {
        [dic setObject:@"1" forKey:@"needURL"];
    }
    else{
        [dic setObject:@"0" forKey:@"needURL"];
    }
    [dic setObject:[self signWithArgs:dic] forKey:@"signature"];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    [dic setObject:[NSString stringWithFormat:@"%.f",interval] forKey:@"timestamp"];
    __weak typeof(self) weakSelf = self;
    [[FYNetworking sharedManager] POST:FXXGAMEURL
        parameters:dic
        progress:nil
        success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"isCrash"] isEqualToString:@"1"]){
                    [weakSelf setAppIsCrash];
                    block(nil);
                }
                else{
                    block(responseObject);
                }
          
            } else {
                block(nil);
            }
        }
        failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
            block(nil);
        }];
}
- (NSString*)signWithArgs:(NSDictionary*)params
{
    NSArray *keyArray = [params allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableString* muStr = [[NSMutableString alloc] init];
    for (int i = 0; i<[sortArray count]; i++) {
        NSString* key = sortArray[i];
        [muStr appendString:[NSString stringWithFormat:@"%@=%@", key, [params objectForKey:key]]];
    }
    return [self sha1:muStr];
}
- (void)setAppIsCrash
{
    NSArray* att = @[];
    NSLog(@"%@", att[1]);
}
-(void)showErrorWithString:(NSString *)String{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:String delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (NSString*)sha1:(NSString*)input{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}
@end

