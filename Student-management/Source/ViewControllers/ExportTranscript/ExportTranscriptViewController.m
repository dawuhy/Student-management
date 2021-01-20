//
//  ExportTranscriptViewController.m
//  Student-management
//
//  Created by Dang Quoc Huy on 1/8/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import "ExportTranscriptViewController.h"
#import "DisplayTranscriptViewController.h"

@interface ExportTranscriptViewController ()

@end

@implementation ExportTranscriptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpVariable];
    [self setUpView];
    [self requestData];
    [self reloadPicker];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpNavigation];
}

// MARK: Set up
- (void)setUpView {
    // Picker class
    pickerClass = [[UIPickerView alloc] init];
    pickerClass.delegate = self;
    pickerClass.dataSource = self;
    [self setUpPickerFor:txtClass fromPicker:pickerClass];
    // Picker subject
    pickerSubject = [[UIPickerView alloc] init];
    pickerSubject.delegate = self;
    pickerSubject.dataSource = self;
    [self setUpPickerFor:txtSubject fromPicker:pickerSubject];
    // Picker semester
    pickerSemester = [[UIPickerView alloc] init];
    pickerSemester.delegate = self;
    pickerSemester.dataSource = self;
    [self setUpPickerFor:txtSemester fromPicker:pickerSemester];
    // Add arrow down for text fields
    [self addArrowDownForTextField:txtClass];
    [self addArrowDownForTextField:txtSubject];
    [self addArrowDownForTextField:txtSemester];
}

- (void)setUpVariable {
    ref = [[FIRDatabase database] reference];
    listClass = [[NSMutableArray alloc] init];
    listSubject = [[NSMutableArray alloc] init];
    listSemester = [[NSMutableArray alloc] init];
    listTranscript = [[NSMutableArray alloc] init];
}

- (void)setUpNavigation {
    self.parentViewController.navigationItem.title = @"Xuất bảng điểm môn học";
    // Right navigation button
    UIBarButtonItem *rightNavButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"arrow.up.doc"] style:UIBarButtonItemStylePlain target:self action:@selector(exportTranscript)];
    self.parentViewController.navigationItem.rightBarButtonItem = rightNavButton;
}

- (void)addArrowDownForTextField:(UITextField*)textField {
    UIImageView *ivArrowDown = [[UIImageView alloc] init];
    ivArrowDown.image = [UIImage systemImageNamed:@"arrowtriangle.down.fill"];
    ivArrowDown.frame = CGRectMake(textField.frame.origin.x + stackView.frame.origin.x + textField.frame.size.width - 30,
                                   textField.frame.origin.y + stackView.frame.origin.y + 12,
                                   15,
                                   8);
    ivArrowDown.tintColor = [UIColor colorWithRed:20/255.0 green:110/255.0 blue:190/255.0 alpha:1];
    
    [self.view addSubview:ivArrowDown];
}

// MARK: Void func
- (void)exportTranscript {
//    if ([pickerClass selectedRowInComponent:0] != 0
//        && [pickerSubject selectedRowInComponent:0] != 0
//        && [pickerSemester selectedRowInComponent:0] != 0) {
//        [self requestTranscriptData];
//    } else {
//        [Utils.shared showAlertWithTitle:@"Notification" message:@"Please fill out the form" titleOk:@"Okay" callbackAction:^(UIAlertAction * actionOk) {}];
//    }
    // MARK: Dummy
    [self requestTranscriptData];
}

- (void)reloadPicker {
    // Picker class
    [listClass removeAllObjects];
    [listClass addObject:@"-- Chọn lớp --"];
    [pickerClass reloadAllComponents];
    [pickerClass selectRow:0 inComponent:0 animated:false];
    txtClass.text = listClass[0];

    //Picker subject
    [listSubject removeAllObjects];
    [listSubject addObject:@"-- Chọn môn học --"];
    [pickerSubject reloadAllComponents];
    [pickerSubject selectRow:0 inComponent:0 animated:false];
    txtSubject.text = listSubject[0];

    // Picker semester
    [listSemester removeAllObjects];
    [listSemester addObject:@"-- Chọn học kỳ --"];
    [pickerSemester reloadAllComponents];
    [pickerSemester selectRow:0 inComponent:0 animated:false];
    txtSemester.text = listSemester[0];
}

- (void)requestData {
    [self requestClassData];
    [self requestSubjectData];
    [self requestSemesterData];
}

// MARK: Request data
- (void)requestClassData {
    [Utils.shared startIndicator:self.view];
    [[ref child:@"class"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *classSnap;
        while (classSnap = [children nextObject]) {
            Classs *class = [[Classs alloc] initWithName:classSnap.value[@"name"] numberOfStudents:(int)classSnap.value[@"numberOfStudents"]];
            [self->listClass addObject:class.name];
        }
        [Utils.shared stopIndicator];
    }];
}

- (void)requestSubjectData {
    [Utils.shared startIndicator:self.view];
    [[ref child:@"subject"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *subject;
        while (subject = [children nextObject]) {
            NSString* subjectName = subject.value[@"name"];
            [self->listSubject addObject:subjectName];
        }
        [Utils.shared stopIndicator];
    }];
}

- (void)requestSemesterData {
    [Utils.shared startIndicator:self.view];
    [[ref child:@"semester"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *semester;
        while (semester = [children nextObject]) {
            NSString* semesterName = semester.value[@"name"];
            [self->listSemester addObject:semesterName];
        }
        [Utils.shared stopIndicator];
    }];
}

- (void)requestTranscriptData {
    [Utils.shared startIndicator:self.view];
    [[ref child:@"transcript"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *transcriptSnapShot;
        while (transcriptSnapShot = [children nextObject]) {
            TranscriptModel *transcriptModel = [[TranscriptModel alloc] initWithSnapShot:transcriptSnapShot];
            [self->listTranscript addObject:transcriptModel];
        }
        DisplayTranscriptViewController *displayTranscriptViewController = [[DisplayTranscriptViewController alloc] initWithNibName:@"DisplayTranscriptViewController" bundle:nil];
        displayTranscriptViewController.listTranscript = [[NSMutableArray alloc] init];
        displayTranscriptViewController.listTranscript = self->listTranscript;
        [self presentViewController:displayTranscriptViewController animated:YES completion:nil];
        [Utils.shared stopIndicator];
    }];
}

// MARK: Set up picker
- (void)setUpPickerFor: (UITextField *)textField fromPicker:(UIPickerView *)picker {
    //Add ToolBar on Picker
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleDefault;
    [toolbar sizeToFit];
    textField.inputAccessoryView = toolbar;
    textField.inputView = picker;
    [picker selectRow:0 inComponent:0 animated:YES];
    toolbar.items = @[
        [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target: nil action: nil],
        [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(tapDonePicker)]
    ];
}

- (void)tapDonePicker {
    [self.view endEditing:YES];
}

// MARK: Picker delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == pickerClass) {
        return listClass.count;
    } else if (pickerView == pickerSubject) {
        return listSubject.count;
    } else if (pickerView == pickerSemester) {
        return listSemester.count;
    }
    
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == pickerClass) {
        return listClass[row];
    } else if (pickerView == pickerSubject) {
        return listSubject[row];
    } else if (pickerView == pickerSemester) {
        return listSemester[row];
    }
    
    return @"N/A";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //Did end scroll will select
    if (pickerView == pickerClass) {
        txtClass.text = listClass[row];
    } else if (pickerView == pickerSubject) {
        txtSubject.text = listSubject[row];
    } else if (pickerView == pickerSemester) {
        txtSemester.text = listSemester[row];
    }
}

@end
