//
//  ViewController.m
//  Student-management
//
//  Created by Dang Quoc Huy on 10/14/20.
//  Copyright © 2020 Dang Quoc Huy. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}
- (IBAction)loginTapped:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainScreen" bundle:nil];
    MainScreenViewController *mainScreenViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainScreenViewController"];
    [self.navigationController pushViewController:mainScreenViewController animated:TRUE];
}

- (IBAction)registerAccountTapped:(id)sender {
    SignUpViewController *registerAccountViewController = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    [self.navigationController pushViewController:registerAccountViewController animated:true];
}

- (IBAction)forgotPasswordTapped:(id)sender {
    ForgotPasswordViewController *forgotPasswordViewController = [[ForgotPasswordViewController alloc] initWithNibName:@"ForgotPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:forgotPasswordViewController animated:true];
}

@end
