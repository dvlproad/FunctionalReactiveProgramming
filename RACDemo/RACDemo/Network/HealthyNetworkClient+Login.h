//
//  HealthyNetworkClient+Login.h
//  RACDemo
//
//  Created by 李超前 on 2017/5/23.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "HealthyNetworkClient.h"

@interface HealthyNetworkClient (Login)

//健康软件中的API
- (void)requestLogin_name:(NSString *)name
                     pasd:(NSString*)pasd
                  success:(AFRequestSuccess)success
                  failure:(AFRequestFailure)failure;

@end
