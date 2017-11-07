//
//  LoginMVVMViewController.m
//  RACDemo
//
//  Created by dvlproad on 2017/3/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "LoginMVVMViewController.h"
#import "HealthyNetworkClient.h"

#import "LoginViewModel.h"

@interface LoginMVVMViewController ()

@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *pasdTextField;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) LoginViewModel *viewModel;

@end


@implementation LoginMVVMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"LoginMVVMViewController", nil);
    
    //Bind
    [self bindViewModel];
    
    
    self.nameTextField.text = @"test";
    self.pasdTextField.text = @"test";
}



//关联ViewModel
- (void)bindViewModel {
    _viewModel = [[LoginViewModel alloc] init];
    
    [self.nameTextField setCjTextDidChangeBlock:^(UITextField *textField) {
        [self.viewModel userNameChangeEvent:textField.text];
    }];
    
    [self.pasdTextField setCjTextDidChangeBlock:^(UITextField *textField) {
        [self.viewModel passwordChangeEvent:textField.text];
    }];
    
    __weak typeof(self)weakSelf = self;
    [self.viewModel setLoginButtonEnableChangeBlock:^(BOOL loginButtonEnable) {
        weakSelf.loginButton.enabled = loginButtonEnable;
    }];
    
    [self.loginButton setCjTouchEventBlock:^(UIButton *button) {
        [self.view endEditing:YES];
        
        [self.viewModel login_health];
    }];
    
    //登录成功要处理的方法
    [self.viewModel setSuccessBlock:^(id responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    //fail
    [self.viewModel setFailureBlock:^(NSError *error) {
        
    }];
    
    //error
    [self.viewModel setErrorBlock:^(NSError *error) {
        
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
