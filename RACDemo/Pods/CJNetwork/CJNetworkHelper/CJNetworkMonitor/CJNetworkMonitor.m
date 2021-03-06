//
//  CJNetworkMonitor.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/19.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "CJNetworkMonitor.h"

@implementation CJNetworkMonitor

+ (CJNetworkMonitor *)sharedInstance {
    static CJNetworkMonitor *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}


/** 完整的描述请参见文件头部 */
- (void)startNetworkMonitoring {
    //AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager manager];//错误
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
    __weak typeof(self)weakSelf = self;
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        weakSelf.networkStatus = status;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                NSLog(@"未识别的网络");
                weakSelf.networkSuccess = NO;
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"不可达的网络(未连接)");
                weakSelf.networkSuccess = NO;
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"2G,3G,4G...的网络");
                weakSelf.networkSuccess = YES;
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"wifi的网络");
                weakSelf.networkSuccess = YES;
                break;
            }
            default:
            {
                break;
            }
        }
    }];
    
    [reachabilityManager startMonitoring];
}

@end
