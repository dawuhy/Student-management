//
//  AddStudentViewController.m
//  Student-management
//
//  Created by Dang Quoc Huy on 10/14/20.
//  Copyright © 2020 Dang Quoc Huy. All rights reserved.
//

#import "AddStudentViewController.h"

@interface AddStudentViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTextField;
@property (weak, nonatomic) IBOutlet UIButton *maleButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *femaleButtonOutlet;
@property (weak, nonatomic) IBOutlet UITextField *numberPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *classTextField;
@end

@implementation AddStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

//MARK:- Void function

-(void)setUpView {
    [self.maleButtonOutlet setBackgroundImage:[UIImage systemImageNamed:@"checkmark.square.fill"] forState:UIControlStateSelected];
    [self.femaleButtonOutlet setBackgroundImage:[UIImage systemImageNamed:@"checkmark.square.fill"] forState:UIControlStateSelected];
}

-(void)saveStudentData {
    FirebaseService *firebase = [[FirebaseService alloc] init];
    
    [firebase addStudentWithName:self.nameTextField.text email:self.emailTextField.text class:self.classTextField.text dateOfBirth:self.dateOfBirthTextField.text numberPhone:self.numberPhoneTextField.text];
}

-(void)showAlertWithMessage: (NSString*)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign up" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:true completion:nil];
}

-(void) showAlertAndPopVC {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notification" message:@"Add student successfully." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:true];
    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:true completion:nil];
}

//MARK:- IBAction
- (IBAction)addAvatarTapped:(id)sender {
    
}

- (IBAction)maleButtonTapped:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (_femaleButtonOutlet.selected) {
        _femaleButtonOutlet.selected = !_femaleButtonOutlet.selected;
    }
}

- (IBAction)femaleButtonTapped:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (_maleButtonOutlet.selected) {
        _maleButtonOutlet.selected = !_maleButtonOutlet.selected;
    }
}

- (IBAction)submitTapped:(id)sender {
    if ([self validateForm]) {
        [self saveStudentData];
        [self showAlertAndPopVC];
    }
}

//MARK:- Validate

-(BOOL) validateDateOfBirthWithString:(NSString*)dateString {
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

-(BOOL) validateEmailWithString:(NSString*)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(BOOL) validateForm {
    if ([[self.nameTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet]  isEqual: @""]) {
        [self showAlertWithMessage:@"Do not leave your name blank."];
        return false;
    } else if (![self validateEmailWithString:self.emailTextField.text]) {
        [self showAlertWithMessage:@"Email is invalid."];
        return false;
    } else if (![self validateDateOfBirthWithString:self.dateOfBirthTextField.text]) {
        [self showAlertWithMessage:@"Date of birth is invalid."];
        return false;
    } else if (_maleButtonOutlet.selected == false && _femaleButtonOutlet.selected == false) {
        [self showAlertWithMessage:@"Please fill gender."];
        return false;
    } else if ([[self.classTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet]  isEqual: @""]) {
        [self showAlertWithMessage:@"Do not leave your class blank."];
        return false;
    }
    return true;
}



@end
