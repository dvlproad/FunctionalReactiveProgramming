//
//  LoginNormalViewController+Event.m
//  RACDemo
//
//  Created by 李超前 on 2017/5/23.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "LoginNormalViewController+Event.h"
#import "HealthyNetworkClient+Login.h"

@implementation LoginNormalViewController (Network)

- (BOOL)loginButtonIsValid {
    return YES;
}

- (void)login_health {
    [self.view endEditing:YES];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"正在登录", nil) maskType:SVProgressHUDMaskTypeBlack];
    
//    NSString *name = self.nameTextField.text;
//    NSString *pasd = self.pasdTextField.text;
    NSString *name = self.userModel.userName;
    NSString *pasd = self.userModel.password;

    __weak typeof(self)weakSelf = self;
    [[HealthyNetworkClient sharedInstance] requestLogin_name:name pasd:pasd success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"登录成功", nil)];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"登录失败", nil)];
    }];
}


@end
