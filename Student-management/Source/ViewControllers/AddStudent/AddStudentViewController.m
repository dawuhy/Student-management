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
-(void)setUpView {
    // Title navigation
    self.navigationItem.title = @"Thêm học sinh";
    // Set image state selected of button
    [self.maleButtonOutlet setBackgroundImage:[UIImage systemImageNamed:@"checkmark.square.fill"] forState:UIControlStateSelected];
    [self.femaleButtonOutlet setBackgroundImage:[UIImage systemImageNamed:@"checkmark.square.fill"] forState:UIControlStateSelected];
    // Right nav button
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(submit:)];
    
    // Drop down of class
//    classDropDown = [[GaiDropDownMenu alloc] initWithFrame:_classTextField.frame title:@"Chọn lớp"];
//    CGRect frame = classDropDown.frame;
////    frame.origin.x = 20;
//    frame.origin.x = 25;
////    frame.origin.y = _dateOfBirthTextField.frame.origin.y + _dateOfBirthTextField.frame.size.height + 12;
//    frame.origin.y = _classTextField.frame.origin.y + stackView.frame.origin.y + self.navigationController.navigationBar.frame.size.height + 4;
//    frame.size.width = (self.view.frame.size.width - 90);
//    frame.size.height = 35;
//    classDropDown.frame = frame;
//    classDropDown.delegate = self;
//    classDropDown.numberOfRows = _listClass.count;
//    NSMutableArray *arrayClassName = [[NSMutableArray alloc] init];
//    for (int i=0; i<_listClass.count; i++) {
//        [arrayClassName addObject:_listClass[i].name];
//    }
//    classDropDown.textOfRows = arrayClassName;
//    [self.view addSubview:classDropDown];
//    classDropDown.inactiveColor = [UIColor blackColor];
    
    // Picker class
    pickerClass = [[UIPickerView alloc] init];
    pickerClass.delegate = self;
    pickerClass.dataSource = self;
    [self setUpPickerFor:_classTextField];
}

- (void)initVariable {
    spinner = [[WaitSpinner alloc] init];
    self.storageRef = [[FIRStorage storage] reference];
    ref = [[FIRDatabase database] reference];
}

- (void)showAlertWithTitle: (NSString*)title message:(NSString*)message{
    if ([title isEqual:@""]) {
        title = @"Notification";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
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
    [self showSpinner];
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
        if (error != nil) {
            [self hideSpinner];
            [self showAlertWithTitle:@"Error" message:error.localizedDescription];
        } else {
            // Metadata contains file metadata such as size, content-type, and download URL.
            //            int64_t size = metadata.size;
            // You can also access to download URL after upload.
            [imgRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                if (error) {
                    [self hideSpinner];
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
            [self hideSpinner];
            [Utils.shared showAlertWithTitle:@"Notification" message:@"Add student success" titleOk:@"OK" callbackAction:^(UIAlertAction * actionOK) {
                [self.navigationController popViewControllerAnimated:true];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataMainScreen" object:nil];
            }];
            
        }
    }];
}

- (void)showSpinner {
    [spinner showInView:self.view];
}


- (void)hideSpinner {
    [spinner hide];
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
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
        [self showAlertWithTitle:@"" message:@"Do not leave your name blank."];
        return false;
    } else if (![self validateEmailWithString:self.emailTextField.text]) {
        [self showAlertWithTitle:@"" message:@"Email is invalid."];
        return false;
    } else if (![self validateDateOfBirthWithString:self.dateOfBirthTextField.text]) {
        [self showAlertWithTitle:@"" message:@"Date of birth is invalid."];
        return false;
    } else if (_maleButtonOutlet.selected == false && _femaleButtonOutlet.selected == false) {
        [self showAlertWithTitle:@"" message:@"Please fill gender."];
        return false;
    } else if ([[self.classTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet]  isEqualToString:@""]) {
        [self showAlertWithTitle:@"" message:@"Do not leave your class blank."];
        return false;
    }
    return true;
}

// MARK: - Text field delegate
// MARK: - Picker delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _listClass.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _listClass[row].name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //Did end scroll will select
//    selectedPrefectureIndex = (int)row;
    _classTextField.text = _listClass[row].name;
}

- (void)setUpPickerFor: (UITextField *)textField {
    if (textField == _classTextField) {
        //Add ToolBar on Picker
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        toolbar.barStyle = UIBarStyleDefault;
        NSString *done = @"Done";
//        NSString *btnCancelDate = @"Cancel";
        [toolbar sizeToFit];
        textField.inputAccessoryView = toolbar;
        
        [pickerClass selectRow:0 inComponent:0 animated:YES];
        textField.inputView = pickerClass;
        toolbar.items = @[
//                            [[UIBarButtonItem alloc]initWithTitle:btnCancelDate style:UIBarButtonItemStyleDone target:self action:@selector(cancelPicker)],
                          [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target: nil action: nil],
                          [[UIBarButtonItem alloc]initWithTitle:done style:UIBarButtonItemStyleDone target:self action:@selector(tapDonePicker)]
        ];
    }
}

-(void)tapDonePicker {
    NSInteger row = [pickerClass selectedRowInComponent:0];
    _classTextField.text = _listClass[row].name;
    
    [self.view endEditing:YES];
}

// MARK: - Drop down delegate
- (void)dropDownMenu:(CCDropDownMenu *)dropDownMenu didSelectRowAtIndex:(NSInteger)index {
    _classTextField.text = _listClass[index].name;
}

// MARK: - Table view delegate
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return _listClass.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    ClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ClassTableViewCell"];
//    [cell configureCellWithClassName: _listClass[indexPath.row].name];
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 44;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    _classTextField.text = _listClass[indexPath.row].name;
//    [tableViewClass setHidden:true];
//}
//
//- (void)updateHeightTableview {
//    [tableViewClass layoutIfNeeded];
//    CGRect frame;
//    frame.size.height = tableViewClass.contentSize.height;
//    tableViewClass.frame = frame;
//}

@end
