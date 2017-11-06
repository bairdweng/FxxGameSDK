//
//  FYNetworking.h
//  Family
//
//  Created by Baird-weng on 2017/8/31.
//  Copyright © 2017年 Baird-weng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//请求成功回调block
typedef void (^requestSuccessBlock)(NSDictionary* dic);
//请求失败回调block
typedef void (^requestFailureBlock)(NSError* error);
//请求方法define
typedef enum {
    GET,
    POST,
    PUT,
    DELETE,
    HEAD
} HTTPMethod;
@interface FYNetworking : AFHTTPSessionManager
+(instancetype)sharedManager;
- (void)requestWithMethod:(HTTPMethod)method
                 WithPath:(NSString*)path
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(requestSuccessBlock)success
          WithFailurBlock:(requestFailureBlock)failure;
@end
