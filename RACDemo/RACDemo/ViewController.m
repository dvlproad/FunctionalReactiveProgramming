//
//  ViewController.m
//  RACDemo
//
//  Created by dvlproad on 2017/3/28.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "ViewController.h"
#import "PersonViewController.h"
#import "NormalLoginViewController.h"
#import "RACLoginViewController.h"

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

- (IBAction)goNormalLoginViewController:(id)sender {
    NormalLoginViewController *viewController = [[NormalLoginViewController alloc] initWithNibName:@"NormalLoginViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)goRACLoginViewController:(id)sender {
    RACLoginViewController *viewController = [[RACLoginViewController alloc] initWithNibName:@"RACLoginViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
