//
//  HealthyNetworkClient+Login.m
//  RACDemo
//
//  Created by 李超前 on 2017/5/23.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "HealthyNetworkClient+Login.h"

@implementation HealthyNetworkClient (Login)

- (void)requestLogin_name:(NSString *)name
                     pasd:(NSString*)pasd
                  success:(AFRequestSuccess)success
                  failure:(AFRequestFailure)failure
{
    NSString *Url = API_BASE_Url_Health(@"login");
    NSDictionary *params = @{@"username" : name,
                             @"password" : pasd
                             };
    AFHTTPSessionManager *manager = [HealthyHTTPSessionManager sharedInstance];
    [manager cj_postRequestUrl:Url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取失败");
        failure(task, error);
    }];
    //    [self.indicatorView setAnimatingWithStateOfOperation:operation];
}


@end
