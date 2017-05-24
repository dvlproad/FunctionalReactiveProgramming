//
//  LoginRACViewModel.h
//  RACDemo
//
//  Created by 李超前 on 2017/3/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface LoginRACViewModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, strong) RACSubject *successObject;
@property (nonatomic, strong) RACSubject *failureObject;
@property (nonatomic, strong) RACSubject *errorObject;

- (id)loginButtonIsValid;
- (void)login_health;

@end
