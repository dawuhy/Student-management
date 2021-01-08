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
    classDropDown = [[GaiDropDownMenu alloc] initWithFrame:_classTextField.frame title:@"Chọn lớp"];
    CGRect frame = classDropDown.frame;
//    frame.origin.x = 20;
    frame.origin.x = 25;
//    frame.origin.y = _dateOfBirthTextField.frame.origin.y + _dateOfBirthTextField.frame.size.height + 12;
    frame.origin.y = _classTextField.frame.origin.y + stackView.frame.origin.y + self.navigationController.navigationBar.frame.size.height + 4;
    frame.size.width = (self.view.frame.size.width - 90);
    frame.size.height = 35;
    classDropDown.frame = frame;
    classDropDown.delegate = self;
    classDropDown.numberOfRows = _listClass.count;
    NSMutableArray *arrayClassName = [[NSMutableArray alloc] init];
    for (int i=0; i<_listClass.count; i++) {
        [arrayClassName addObject:_listClass[i].name];
    }
    classDropDown.textOfRows = arrayClassName;
    [self.view addSubview:classDropDown];
    classDropDown.inactiveColor = [UIColor blackColor];
    
//    _classTextField.delegate = self;
//    // Table view drop down of class
//    tableViewClass = [[UITableView alloc] initWithFrame: CGRectMake(
//                    _classTextField.frame.origin.x,
//                    _classTextField.frame.origin.y+_classTextField.frame.size.height,
//                    _classTextField.frame.size.width,
//                    44
//                                                                    )];
//    tableViewClass.delegate = self;
//    tableViewClass.dataSource = self;
//    [self.view addSubview: tableViewClass];
//    tableViewClass.layer.cornerRadius = 10;
//    tableViewClass.layer.masksToBounds = YES;
//    [tableViewClass setHidden:true];
//    [tableViewClass setScrollEnabled: false];
//    UINib *nibClassCell = [UINib nibWithNibName:@"ClassTableViewCell" bundle:nil];
//    [self->tableViewClass registerNib:nibClassCell forCellReuseIdentifier:@"ClassTableViewCell"];
}

- (void)initVariable {
    self.spinner = [[WaitSpinner alloc] init];
    self.firebase = [[FirebaseService alloc] init];
    self.storageRef = [[FIRStorage storage] reference];
}

-(void)showAlertWithTitle: (NSString*)title message:(NSString*)message{
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
            [self showAlertWithTitle:@"" message:error.localizedDescription];
        } else {
            // Metadata contains file metadata such as size, content-type, and download URL.
            //            int64_t size = metadata.size;
            // You can also access to download URL after upload.
            [imgRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                if (error != nil) {
                    [self hideSpinner];
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
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    if (textField == _classTextField) {
//        [tableViewClass setHidden: true];
//    }
//}
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    if (textField == _classTextField) {
//        [self updateHeightTableview];
//        [tableViewClass setHidden: false];
//    }
//    return YES;
//}

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
