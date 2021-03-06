//
//  LoginViewModel.h
//  RACDemo
//
//  Created by 李超前 on 2017/3/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CJBaseUIKit/UITextField+CJTextChangeBlock.h>
#import <CJBaseUIKit/UIButton+CJTouchEvent.h>

@interface LoginViewModel : NSObject

@property (nonatomic, copy) void (^loginButtonEnableChangeBlock)(BOOL loginButtonEnable);

@property (nonatomic, copy) void (^successBlock)(id responseObject);
@property (nonatomic, copy) void (^failureBlock)(NSError *error);
@property (nonatomic, copy) void (^errorBlock)( NSError *error);


- (void)userNameChangeEvent:(NSString *)userName;
- (void)passwordChangeEvent:(NSString *)password;

//- (id)loginButtonIsValid;
- (void)login_health;

@end
