//
//  LoginViewController.m
//  RACDemo
//
//  Created by dvlproad on 2017/3/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "LoginViewController.h"
#import "HealthyNetworkClient.h"

@interface LoginViewController ()

@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *pasdTextField;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.nameTextField.text = @"test";
    self.pasdTextField.text = @"test";
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)login_health:(id)sender{
    [self.view endEditing:YES];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"正在登录", nil) maskType:SVProgressHUDMaskTypeBlack];
    
    NSString *name = self.nameTextField.text;
    NSString *pasd = self.pasdTextField.text;
    [[HealthyNetworkClient sharedInstance] requestLogin_name:name pasd:pasd success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"登录成功", nil)];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"登录失败", nil)];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end