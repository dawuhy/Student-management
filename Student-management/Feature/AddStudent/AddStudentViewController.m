//
//  AddStudentViewController.m
//  Student-management
//
//  Created by Dang Quoc Huy on 10/14/20.
//  Copyright © 2020 Dang Quoc Huy. All rights reserved.
//

#import "AddStudentViewController.h"

@interface AddStudentViewController ()

@end

@implementation AddStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

//MARK:- Void function
-(void)setUpView {
    self.firebase = [[FirebaseService alloc] init];
    self.storageRef = [[FIRStorage storage] reference];
    [self.maleButtonOutlet setBackgroundImage:[UIImage systemImageNamed:@"checkmark.square.fill"] forState:UIControlStateSelected];
    [self.femaleButtonOutlet setBackgroundImage:[UIImage systemImageNamed:@"checkmark.square.fill"] forState:UIControlStateSelected];
    
    self.spinner = [[WaitSpinner alloc] init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(submit:)];
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


-(void) saveStudentInfo {
    // Save avatar
    FIRStorageReference *imgRef = [self.storageRef child:[NSString stringWithFormat:@"images/%@.png", self.emailTextField.text]];
    NSData* imgData = UIImagePNGRepresentation(self.avatarImageView.image);
    UIImage *image = self.avatarImageView.image;
    // Resize image
    // Check if the image size is too large
    
    while ((imgData.length/1024) >= 1024) {
        NSLog(@"While start - The imagedata size is currently: %f KB", roundf(imgData.length/1024));
        image = [self imageWithImage:image convertToSize:CGSizeMake(image.size.width * 0.95, image.size.height * 0.95)];
        imgData = UIImageJPEGRepresentation(image, 1);
        NSLog(@"to: %f KB", roundf(imgData.length/1024));
    }
    
    [imgRef
     putData:imgData
     metadata:nil
     completion:^(FIRStorageMetadata *metadata,
                  NSError *error) {
        if (error != nil) {
            NSLog(@"**************\n%@\n**************", error.localizedDescription);
        } else {
            // Metadata contains file metadata such as size, content-type, and download URL.
            //            int64_t size = metadata.size;
            // You can also access to download URL after upload.
            [imgRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"**************\n%@\n**************", error.localizedDescription);
                } else {
                    self.avatarURL = URL;
                    NSLog(@"Upload image success.");
                    [self saveDataToFireBase];
                    [self showAlertAndPopVC];
                    [self hideSpinner];
                }
            }];
        }
    }];
}

-(void) saveDataToFireBase {
    //    [self.firebase addStudentWithName:_nameTextField.text email:_emailTextField.text class:_classTextField.text dateOfBirth:_dateOfBirthTextField.text gender:[NSNumber numberWithBool:(self.maleButtonOutlet.isSelected)] numberPhone:_numberPhoneTextField.text avatarURL:_avatarURL.absoluteString address:_addressTextField.text];
    
    NSDictionary<NSString*, id> *studentDict = @{ @"name": _nameTextField.text,
                                                  @"email": _emailTextField.text,
                                                  @"class": _classTextField.text,
                                                  @"dateOfBirth": _dateOfBirthTextField.text,
                                                  @"gender": [NSNumber numberWithBool:(self.maleButtonOutlet.isSelected)],
                                                  @"numberPhone": _numberPhoneTextField.text,
                                                  @"address": _addressTextField.text,
                                                  @"avatarURL": _avatarURL.absoluteString
    };
    [self.firebase addStudentWithDict:studentDict];
}

-(void) showSpinner {
    [self.spinner showInView:self.view];
}


-(void) hideSpinner {
    [self.spinner hide];
}

//MARK:- IBAction
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
        [self showSpinner];
        [self saveStudentInfo];
    }
}

// MARK:- Add avatar
- (IBAction)addAvatarTapped:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.avatarImageView.image = img;
    //    self.imgData = UIImagePNGRepresentation(img);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
    } else if ([[self.classTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet]  isEqualToString:@""]) {
        [self showAlertWithMessage:@"Do not leave your class blank."];
        return false;
    }
    return true;
}

@end
