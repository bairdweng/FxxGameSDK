//
//  FXXGameSDK.h
//  CSGameMb
//
//  Created by Baird-weng on 2017/11/4.
//  Copyright © 2017年 Baird-weng. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^resultBlock)(NSDictionary* dictionary);
@interface FXXGameSDK : NSObject
+ (instancetype)sharedManager;
- (void)registeredWithNeedURL:(BOOL)isNeedURL withResultBlock:(resultBlock)block;
@end
