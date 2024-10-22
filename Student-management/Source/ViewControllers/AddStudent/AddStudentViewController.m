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
    
    [self initVariable];
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

//MARK:- Void function
- (void)setUpView {
    self.dateOfBirthTextField.delegate = self;
    // Title navigation
    self.navigationItem.title = @"Thêm học sinh";
    // Set image state selected of button
    [self.maleButtonOutlet setBackgroundImage:[UIImage systemImageNamed:@"checkmark.square.fill"] forState:UIControlStateSelected];
    [self.femaleButtonOutlet setBackgroundImage:[UIImage systemImageNamed:@"checkmark.square.fill"] forState:UIControlStateSelected];
    
    // Picker class
    
    pickerClass = [[UIPickerView alloc] init];
    pickerClass.delegate = self;
    pickerClass.dataSource = self;
    [self setUpPickerFor:_classTextField];
    isFillClass = false;
    
    // Date picker
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    [datePicker addTarget:self action:@selector(datePickerDidChange) forControlEvents:UIControlEventValueChanged];
    [self setUpDateTimePickerFor: self.dateOfBirthTextField];
    self.dateOfBirthTextField.text = @"-- Chọn ngày sinh --";
    isFillDate = false;
    
    [self addArrowDownForTextField:self.dateOfBirthTextField];
    [self addArrowDownForTextField:self.classTextField];
}

- (void)initVariable {
    self.storageRef = [[FIRStorage storage] reference];
    ref = [[FIRDatabase database] reference];
}

//- (reloadDataClassPicker) {
//    
//}

- (void)showAlertWithTitle: (NSString*)title message:(NSString*)message{
    if ([title isEqual:@""]) {
        title = @"Notification";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)showAlertAndPopVC {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notification" message:@"Add student successfully." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:true];
    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:true completion:nil];
}


-(void) saveStudentInfo {
    [Utils.shared startIndicator:self.view];
    // Save avatar
    FIRStorageReference *imgRef = [self.storageRef child:[NSString stringWithFormat:@"images/%@.png", self.emailTextField.text]];
    NSData* imgData = UIImagePNGRepresentation(self.avatarImageView.image);
    UIImage *image = self.avatarImageView.image;
    // Check if the image size is too large
    if ((imgData.length/1024) >= 1024) {
        while ((imgData.length/1024) >= 1024) {
            image = [self imageWithImage:image convertToSize:CGSizeMake(image.size.width * 0.9, image.size.height * 0.9)];
            imgData = UIImageJPEGRepresentation(image, 0.9);
            NSLog(@"The imagedata size is currently: %f KB", roundf(imgData.length/1024));
        }
    }
    
    [imgRef putData:imgData
           metadata:nil
         completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error) {
            [Utils.shared stopIndicator];
            [self showAlertWithTitle:@"Error" message:error.localizedDescription];
        } else {
            // Metadata contains file metadata such as size, content-type, and download URL.
            //            int64_t size = metadata.size;
            // You can also access to download URL after upload.
            [imgRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                if (error) {
                    
                    [self showAlertWithTitle:@"Error" message:error.localizedDescription];
                } else {
                    self.avatarURL = URL;
                    NSLog(@"Upload image success.");
                    [self saveDataToFireBase];
                    
                }
            }];
        }
    }];
}

-(void) saveDataToFireBase {
    [Utils.shared startIndicator: self.view];
    NSDictionary<NSString*, id> *studentDict = @{ @"name": _nameTextField.text,
                                                  @"email": _emailTextField.text,
                                                  @"class": _classTextField.text,
                                                  @"dateOfBirth": _dateOfBirthTextField.text,
                                                  @"gender": [NSNumber numberWithBool:(self.maleButtonOutlet.isSelected)],
                                                  @"numberPhone": _numberPhoneTextField.text,
                                                  @"address": _addressTextField.text,
                                                  @"avatarURL": _avatarURL.absoluteString
    };
    [[[ref child: @"student"] childByAutoId] setValue:studentDict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            NSLog(@"ERROR: %@", error.localizedDescription);
            [Utils.shared showAlertWithTitle:@"Error" message:error.localizedDescription titleOk:@"OK" callbackAction:^(UIAlertAction * actionOk) {}];
        } else {
            [Utils.shared stopIndicator];
            [Utils.shared showAlertWithTitle:@"Notification" message:@"Add student success" titleOk:@"OK" callbackAction:^(UIAlertAction * actionOK) {
                [self.navigationController popViewControllerAnimated:true];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataMainScreen" object:nil];
            }];
            
        }
    }];
}

- (void)addArrowDownForTextField:(UITextField*)textField {
    UIImageView *ivArrowDown = [[UIImageView alloc] init];
    ivArrowDown.image = [UIImage systemImageNamed:@"arrowtriangle.down.fill"];
    ivArrowDown.frame = CGRectMake(textField.frame.origin.x
                                   + stackView.frame.origin.x
                                   + textField.frame.size.width - 30,
                                   // y
                                   textField.frame.origin.y
                                   + stackView.frame.origin.y
                                   + 12 + 47,
                                   // width
                                   15,
                                   // height
                                   8);
    ivArrowDown.tintColor = [UIColor colorWithRed:20/255.0 green:110/255.0 blue:190/255.0 alpha:1];
    
    [self.view addSubview:ivArrowDown];
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

-(void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.avatarImageView.image = img;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
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
        [self showAlertWithTitle:@"" message:@"Do not leave your name blank."];
        return false;
    } else if (![self validateEmailWithString:self.emailTextField.text]) {
        [self showAlertWithTitle:@"" message:@"Email is invalid."];
        return false;
    } else if (!isFillDate) {
        [self showAlertWithTitle:@"" message:@"Please choose date of birth's student."];
        return false;
    } else if (_maleButtonOutlet.selected == false && _femaleButtonOutlet.selected == false) {
        [self showAlertWithTitle:@"" message:@"Please fill gender."];
        return false;
    } else if (!isFillClass) {
        [self showAlertWithTitle:@"" message:@"Please choose class of student."];
        return false;
    }
    return true;
}

// MARK: - Text field delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.dateOfBirthTextField) {
        isFillDate = true;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
        self.dateOfBirthTextField.text = [dateFormatter stringFromDate:[datePicker date]];
    }
    
    return YES;
}


// MARK: - Picker delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _listClassName.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _listClassName[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //Did end scroll will select
    //    selectedPrefectureIndex = (int)row;
    isFillClass = true;
    _classTextField.text = _listClassName[row];
}

- (void)setUpPickerFor: (UITextField *)textField {
    // Toolbar
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleDefault;
    [toolbar sizeToFit];
    toolbar.items = @[
        [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target: nil action: nil],
        [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(tapDoneClassPicker)]
    ];
    if (textField == _classTextField) {
        textField.inputAccessoryView = toolbar;
        [pickerClass selectRow:0 inComponent:0 animated:YES];
        textField.inputView = pickerClass;
        [pickerClass selectRow:0 inComponent:0 animated:NO];
        self.classTextField.text = _listClassName[0];
    }
}

-(void)tapDoneClassPicker {
//    NSInteger row = [pickerClass selectedRowInComponent:0];
//    _classTextField.text = _listClass[row].name;
    
    [self.view endEditing:YES];
}

- (void)setUpDateTimePickerFor: (UITextField *)textField {
    // Toolbar
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleDefault;
    [toolbar sizeToFit];
    toolbar.items = @[
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target: nil action: nil],
        [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(tapDoneDatePicker)]
    ];
    
    textField.inputAccessoryView = toolbar;
    textField.inputView = datePicker;
}

- (void)tapDoneDatePicker {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MM-yyyy";
    self.dateOfBirthTextField.text = [dateFormatter stringFromDate:[datePicker date]];
    [self.view endEditing:YES];
}

- (void)datePickerDidChange {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MM-yyyy";
    self.dateOfBirthTextField.text = [dateFormatter stringFromDate:[datePicker date]];
}

@end
