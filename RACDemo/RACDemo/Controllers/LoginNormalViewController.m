//
//  LoginNormalViewController.m
//  RACDemo
//
//  Created by dvlproad on 2017/3/30.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "LoginNormalViewController.h"
#import "LoginNormalViewController+Event.h"

@interface LoginNormalViewController ()

@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *pasdTextField;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation LoginNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"LoginNormalViewController", nil);
    
    self.nameTextField.text = @"ciyouzen";
    self.pasdTextField.text = @"123456";
    [self.loginButton addTarget:self action:@selector(login_health) forControlEvents:UIControlEventTouchUpInside];
    
    [self performSelector:@selector(getLastestLoginUser) withObject:nil afterDelay:1];
}

- (void)getLastestLoginUser {
    UserModel *lastestLoginUser = [[UserModel alloc] init];
    lastestLoginUser.userName = @"test";
    lastestLoginUser.password = @"test";
    self.userModel = lastestLoginUser;
    
    self.nameTextField.text = lastestLoginUser.userName;
    self.pasdTextField.text = lastestLoginUser.userName;
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
