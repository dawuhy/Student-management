//
//  ViewController.m
//  Student-management
//
//  Created by Dang Quoc Huy on 10/14/20.
//  Copyright © 2020 Dang Quoc Huy. All rights reserved.
//

#import "LoginViewController.h"
#import <FirebaseDatabase.h>
#import "TabBarViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ref = [[FIRDatabase database] reference];
}

//MARK:- IBAction

- (IBAction)registerAccountTapped:(id)sender {
    SignUpViewController *registerAccountViewController = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    [self.navigationController pushViewController:registerAccountViewController animated:true];
}

- (IBAction)forgotPasswordTapped:(id)sender {
    ForgotPasswordViewController *forgotPasswordViewController = [[ForgotPasswordViewController alloc] initWithNibName:@"ForgotPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:forgotPasswordViewController animated:true];
}

- (IBAction)loginButtonTapped:(id)sender {
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainScreen" bundle:nil];
//    MainScreenViewController *mainScreenViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainScreenViewController"];
//    [self.navigationController pushViewController:mainScreenViewController animated:true];
    
    TabBarViewController *tabBarViewController = [[TabBarViewController alloc] init];
    [self.navigationController pushViewController:tabBarViewController animated:true];
    
//        [[self.ref child:@"user"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//            bool isLoginSuccess = true;
//            NSLog(@"%@", self.passwordTextField.text);
//            NSEnumerator *children = [snapshot children];
//            FIRDataSnapshot *userAccount;
//            while (userAccount = [children nextObject]) {
//                if ([self.userNameTextField.text isEqualToString:[userAccount childSnapshotForPath:@"userName"].value]
//                    && [self.passwordTextField.text isEqualToString:[userAccount childSnapshotForPath:@"password"].value]) {
//                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainScreen" bundle:nil];
//                    MainScreenViewController *mainScreenViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainScreenViewController"];
//                    [self.navigationController pushViewController:mainScreenViewController animated:true];
//                    isLoginSuccess = true;
//                    break;
//                } else {
//                    isLoginSuccess = false;
//                }
//            }
//            if (!isLoginSuccess) {
//                [self showAlertWithMessage:@"Username or password incorrect."];
//            }
//        }];
}

-(void) showAlertWithMessage: (NSString*)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notification" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:true completion:nil];
}

@end