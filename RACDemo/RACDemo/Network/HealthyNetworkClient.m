//
//  HealthyNetworkClient.m
//  CommonAFNUtilDemo
//
//  Created by dvlproad on 2016/12/20.
//  Copyright © 2016年 ciyouzen. All rights reserved.
//

#import "HealthyNetworkClient.h"

@implementation HealthyNetworkClient

+ (HealthyNetworkClient *)sharedInstance {
    static HealthyNetworkClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}


@end
