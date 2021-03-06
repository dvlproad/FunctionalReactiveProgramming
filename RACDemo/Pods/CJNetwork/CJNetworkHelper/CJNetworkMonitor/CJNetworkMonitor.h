//
//  CJNetworkMonitor.h
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/19.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

/**
 *  存储网络状态的类
 */
@interface CJNetworkMonitor : NSObject

@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;
@property (nonatomic, assign, getter=isNetworkSuccess) BOOL networkSuccess; /**< 网络是否可达（WWAN和WiFi为YES） */

/**
 *  创建单例
 *
 *  @return 单例
 */
+ (CJNetworkMonitor *)sharedInstance;


/**
 *  开启网络监听
 */
- (void)startNetworkMonitoring;

@end
