//
//  CJNetworkClientHTTPSessionManager.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface CJNetworkClientHTTPSessionManager : AFHTTPSessionManager

+ (AFHTTPSessionManager *)sharedInstance;

@end
