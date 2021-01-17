//
//  AddClassViewController.m
//  Student-management
//
//  Created by Dang Quoc Huy on 10/16/20.
//  Copyright © 2020 Dang Quoc Huy. All rights reserved.
//

#import "AddClassViewController.h"

@interface AddClassViewController ()


@end

@implementation AddClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ref = [[FIRDatabase database] reference];
    [self setUpView];
}

// MARK:- IBAction
- (IBAction) submitButtonTapped:(id)sender {
    if ([self validateForm]) {
        [self saveClassInfo];
    }
}

// MARK:- Customize function
-(BOOL) validateForm {
    if ([[classTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet] isEqualToString:@""]) {
        [self showAlertWithMessage:@"Don't leave your class name blank."];
        return false;
    }
    return true;
}

-(void) setUpView {
    self.title = @"Thêm lớp học";
}

- (void)saveClassInfo {
    [Utils.shared startIndicator:self.view];
    NSDictionary<NSString*, id> *dic = @{ @"name": classTextField.text,
                                          @"numberOfStudents": @30,
    };
    [[[ref child:@"class"] child:classTextField.text] setValue:dic withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        [Utils.shared stopIndicator];
        if (error) {
            [Utils.shared showAlertWithTitle:@"Error" message:error.localizedDescription titleOk:@"OK" callbackAction:^(UIAlertAction * actionOK) {}];
        } else {
            [self showAlertSuccess];
            [self.navigationController popViewControllerAnimated:true];
        }
    }];
}

- (void)showAlertWithMessage: (NSString*)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign up" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)showAlertSuccess {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notification" message:@"Add class successfully." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:true];
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:true completion:nil];
}

@end
