//
//  LoginViewModel.m
//  RACDemo
//
//  Created by 李超前 on 2017/3/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "LoginViewModel.h"
#import "HealthyNetworkClient+Login.h"

@interface LoginViewModel ()

@property (nonatomic, strong) NSArray *requestData;

@end



@implementation LoginViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
}

- (void)userNameChangeEvent:(NSString *)userName {
    self.userName = userName;
    
    if (self.loginButtonEnableChangeBlock) {
        BOOL loginButtonEnable = self.userName.length >= 4 && self.password.length >= 4;
        NSLog(@"%@, %@, %@", loginButtonEnable ? @"YES" : @"NO", self.userName, self.password);
        self.loginButtonEnableChangeBlock(loginButtonEnable);
    }
    
    
}

- (void)passwordChangeEvent:(NSString *)password {
    self.password = password;
    
    if (self.loginButtonEnableChangeBlock) {
        BOOL loginButtonEnable = self.userName.length >= 4 && self.password.length >= 4;
        NSLog(@"%@, %@, %@", loginButtonEnable ? @"YES" : @"NO", self.userName, self.password);
        self.loginButtonEnableChangeBlock(loginButtonEnable);
    }
}


- (void)login_health {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"正在登录", nil) maskType:SVProgressHUDMaskTypeBlack];
    
    NSString *name = self.userName;
    NSString *pasd = self.password;
    [[HealthyNetworkClient sharedInstance] requestLogin_name:name pasd:pasd success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"登录成功", nil)];
        
        //成功发送成功的信号
        if (self.successBlock) {
            self.successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"登录失败", nil)];
        
        //业务逻辑失败和网络请求失败发送fail或者error信号并传参
        if (self.failureBlock) {
            self.failureBlock(error);
        }
    }];
}


@end
