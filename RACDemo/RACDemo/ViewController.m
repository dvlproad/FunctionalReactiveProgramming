//
//  ViewController.m
//  RACDemo
//
//  Created by dvlproad on 2017/3/28.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "ViewController.h"
#import "PersonViewController.h"
#import "LoginViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"首页", nil);
}


- (IBAction)goPersonViewController:(id)sender {
    PersonViewController *viewController = [[PersonViewController alloc] initWithNibName:@"PersonViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)goLoginViewController:(id)sender {
    LoginViewController *viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
