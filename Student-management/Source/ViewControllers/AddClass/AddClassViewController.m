//
//  AddClassViewController.m
//  Student-management
//
//  Created by Dang Quoc Huy on 10/16/20.
//  Copyright © 2020 Dang Quoc Huy. All rights reserved.
//

#import "AddClassViewController.h"

@interface AddClassViewController ()
@property (weak, nonatomic) IBOutlet UITextField *classTextField;

@end

@implementation AddClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

// MARK:- IBAction
- (IBAction) submitButtonTapped:(id)sender {
    if ([self validateForm]) {
        [self saveClassInfo];
        [self showAlertAndPopVC];
    }
}

// MARK:- Customize function
-(BOOL) validateForm {
    if ([[_classTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet] isEqualToString:@""]) {
        [self showAlertWithMessage:@"Don't leave your class name blank."];
        return false;
    }
    return true;
}

-(void) setUpView {
    self.firebase = [[FirebaseService alloc] init];
}

-(void) saveClassInfo {
    [self.firebase addClassWithName:self.classTextField.text];
}

-(void)showAlertWithMessage: (NSString*)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign up" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:true completion:nil];
}

-(void) showAlertAndPopVC {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notification" message:@"Add class successfully." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:true];
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:true completion:nil];
}

@end
