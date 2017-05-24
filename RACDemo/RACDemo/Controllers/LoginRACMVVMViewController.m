//
//  LoginRACMVVMViewController.m
//  RACDemo
//
//  Created by dvlproad on 2017/3/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "LoginRACMVVMViewController.h"
#import "HealthyNetworkClient.h"

#import "LoginRACViewModel.h"

@interface LoginRACMVVMViewController ()

@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *pasdTextField;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) LoginRACViewModel *viewModel;

@end


@implementation LoginRACMVVMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"LoginRACMVVMViewController", nil);
    
    self.nameTextField.text = @"test";
    self.pasdTextField.text = @"test";
    
    //RAC
    [self bindViewModel];
    
    RAC(self.loginButton, enabled) = [self.viewModel loginButtonIsValid];
    
    @weakify(self);
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]  //按钮点击事件
     subscribeNext:^(id x) {
         @strongify(self)
         [self.view endEditing:YES];
         [_viewModel login_health];
     }];
}

//关联ViewModel
- (void)bindViewModel {
    _viewModel = [[LoginRACViewModel alloc] init];
    
    RAC(self.viewModel, userName) = self.nameTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.pasdTextField.rac_textSignal;
    
    @weakify(self);
    
    //登录成功要处理的方法
    [self.viewModel.successObject subscribeNext:^(id responseObject) {
        @strongify(self);
        NSLog(@"responseObject = %@", responseObject);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    //fail
    [self.viewModel.failureObject subscribeNext:^(id x) {
        
    }];
    
    //error
    [self.viewModel.errorObject subscribeNext:^(id x) {
        
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
