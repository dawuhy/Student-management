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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.userNameTextField becomeFirstResponder];
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
    // Dummy
//    TabBarViewController *tabBarViewController = [[TabBarViewController alloc] init];
//    [self.navigationController pushViewController:tabBarViewController animated:true];
    
    // Custom
//    [spinner showInView:self.view];
//    [[self.ref child:@"user"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        bool isLoginSuccess = true;
//        NSEnumerator *children = [snapshot children];
//        FIRDataSnapshot *userAccount;
//        while (userAccount = [children nextObject]) {
//            if ([self.userNameTextField.text isEqualToString:[userAccount childSnapshotForPath:@"userName"].value]
//                && [self.passwordTextField.text isEqualToString:[userAccount childSnapshotForPath:@"password"].value]) {
//                // Login success
//                TabBarViewController *tabBarViewController = [[TabBarViewController alloc] init];
//                [self.navigationController pushViewController:tabBarViewController animated:true];
//                isLoginSuccess = true;
//                break;
//            } else {
//                isLoginSuccess = false;
//            }
//        }
//        if (!isLoginSuccess) {
//            [self showAlertWithMessage:@"Username or password incorrect."];
//        }
//        [self->spinner hide];
//    }];
    
    // Query
    [Utils.shared startIndicator:self.view];
    [[[[self.ref child:@"user"] queryOrderedByChild:@"userName"] queryEqualToValue:self.userNameTextField.text] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([(NSString*)[[snapshot children] nextObject].value[@"password"] isEqualToString:self.passwordTextField.text]) {
            TabBarViewController *tabBarViewController = [[TabBarViewController alloc] init];
            [self.navigationController pushViewController:tabBarViewController animated:true];
            // Reset text fields
            self.userNameTextField.text = @"";
            self.passwordTextField.text = @"";
        } else {
            [self showAlertWithMessage:@"Username or password incorrect."];
        }
        [Utils.shared stopIndicator];
    }];
}

-(void) showAlertWithMessage: (NSString*)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notification" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:true completion:nil];
}

@end
