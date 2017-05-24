//
//  HealthyNetworkClient.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CJNetwork/AFHTTPSessionManager+CJCategory.h>

#import "HealthyHTTPSessionManager.h"

@interface HealthyNetworkClient : NSObject

+ (HealthyNetworkClient *)sharedInstance;

@end
