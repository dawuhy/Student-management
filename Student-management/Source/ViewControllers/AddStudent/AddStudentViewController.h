//
//  AddStudentViewController.h
//  Student-management
//
//  Created by Dang Quoc Huy on 10/14/20.
//  Copyright © 2020 Dang Quoc Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirebaseService.h"
#import <FirebaseStorage/FirebaseStorage.h>
#import <WaitSpinner.h>
#import "Classs.h"
#import "ClassTableViewCell.h"
#import <CCDropDownMenus/CCDropDownMenus.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddStudentViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CCDropDownMenuDelegate> {
    UITableView *tableViewClass;
    GaiDropDownMenu *classDropDown;
    __weak IBOutlet UIStackView *stackView;
}

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTextField;
@property (weak, nonatomic) IBOutlet UIButton *maleButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *femaleButtonOutlet;
@property (weak, nonatomic) IBOutlet UITextField *numberPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *classTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@property (strong, nonatomic) FirebaseService *firebase;
@property FIRStorageReference *storageRef;
@property NSURL* avatarURL;
@property WaitSpinner* spinner;

@property NSMutableArray<Classs*> *listClass;

@end

NS_ASSUME_NONNULL_END
