//
//  RegisterAccountViewController.m
//  Student-management
//
//  Created by Dang Quoc Huy on 10/14/20.
//  Copyright © 2020 Dang Quoc Huy. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmInfomationButtonOutlet;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ref = [[FIRDatabase database] reference];
    [self setUpView];
}

//MARK:- Void function

-(void)setUpView {
    self.navigationItem.title = @"Đăng ký";
    [self.confirmInfomationButtonOutlet setBackgroundImage:[UIImage systemImageNamed:@"checkmark.square.fill"] forState:UIControlStateSelected];
}

-(void)signUpAccount {
    [Utils.shared startIndicator:self.view];
    NSDictionary<NSString*, id> *userDict = @{ @"userName": self.userNameTextField.text,
                                               @"password": self.passwordTextField.text,
                                               @"email": self.emailTextField.text,
                                               @"dateOfBirth": self.dateOfBirthTextField.text,
                                               @"numberPhone": self.numberPhoneTextField.text };
    [[[ref child:@"user"] childByAutoId] setValue:userDict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            [Utils.shared showAlertWithTitle:@"Error" message:error.localizedDescription titleOk:@"OK" callbackAction:^(UIAlertAction * actionOK) {}];
        } else {
            [Utils.shared stopIndicator];
            [Utils.shared showAlertWithTitle:@"" message:@"Register success." titleOk:@"OK" callbackAction:^(UIAlertAction * actionOk) {
                [self.navigationController popViewControllerAnimated:true];
            }];
        }
    }];
}

//MARK:- IBAction
- (IBAction)confirmInfomationTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)submitButtonTapped:(id)sender {
    if ([self validateForm]) {
        [self signUpAccount];
    }
}

// MARK:- Validate form
- (BOOL)validateEmailWithString:(NSString*)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(BOOL)validateDateOfBirthWithString:(NSString*)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    //dateFormatter.dateFormat = @"dd-MM-yyyy";
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    if(date == nil) {
        return false;
    } else {
        return true;
    }
}

-(BOOL)validatePassword {
    return [self isValidPassword:self.passwordTextField.text];
}

-(BOOL)isValidPassword: (NSString*)password {
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"];
    return [passwordTest evaluateWithObject:password];
}

-(bool) isValidUserName: (NSString*)userName {
    NSPredicate *userNameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^(?=.*[a-z])[A-Za-z\\d$@$#!%*?&]{6,}"];
    return [userNameTest evaluateWithObject:userName];
}

-(BOOL)validateConfirmPassword {
    return ([self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]);
}

-(BOOL)validateForm {
    if (![self isValidUserName:self.userNameTextField.text]) {
        //        [self showAlertWithMessage:@"Do not leave your username blank."];
        [self showAlertWithMessage:@"1. Username length is 6.\n2. One Alphabet in username.\n"];
        return false;
    } else if (![self validateEmailWithString:self.emailTextField.text]) {
        [self showAlertWithMessage:@"Email is invalid."];
        return false;
    } else if (![self validateDateOfBirthWithString:self.dateOfBirthTextField.text]) {
        [self showAlertWithMessage:@"Date of birth is invalid."];
        return false;
    }else if (![self validatePassword]) {
        [self showAlertWithMessage:@"1. Password length is 8.\n2. One Alphabet in Password.\n3. One Special Character in Password. "];
        return false;
    } else if(![self validateConfirmPassword]) {
        [self showAlertWithMessage:@"Re-enter password does not match."];
        return false;
    } else if(!self.confirmInfomationButtonOutlet.selected) {
        [self showAlertWithMessage:@"Unconfirmed information."];
        return false;
    }
    
    return true;
}

// MARK:- Show alert
-(void) showAlertAndPopVC {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign up" message:@"Sign up successfully." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:true];
    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:true completion:nil];
}

-(void) showAlertWithMessage: (NSString*)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notification" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:true completion:nil];
}

@end
