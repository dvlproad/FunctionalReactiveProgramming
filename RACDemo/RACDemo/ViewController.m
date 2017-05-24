//
//  ViewController.m
//  RACDemo
//
//  Created by dvlproad on 2017/3/28.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "ViewController.h"
#import "TestRACViewController.h"
#import "LoginNormalViewController.h"
#import "LoginMVVMViewController.h"
#import "LoginRACMVVMViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"首页", nil);
}


- (IBAction)goTestRACViewController:(id)sender {
    TestRACViewController *viewController = [[TestRACViewController alloc] initWithNibName:@"TestRACViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)goLoginNormalViewController:(id)sender {
    LoginNormalViewController *viewController = [[LoginNormalViewController alloc] initWithNibName:@"LoginNormalViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)goLoginMVVMViewController:(id)sender {
    LoginMVVMViewController *viewController = [[LoginMVVMViewController alloc] initWithNibName:@"LoginMVVMViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)goLoginRACMVVMViewController:(id)sender {
    LoginRACMVVMViewController *viewController = [[LoginRACMVVMViewController alloc] initWithNibName:@"LoginRACMVVMViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
