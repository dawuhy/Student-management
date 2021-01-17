//
//  ExportTranscriptViewController.m
//  Student-management
//
//  Created by Dang Quoc Huy on 1/8/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import "ExportTranscriptViewController.h"

@interface ExportTranscriptViewController ()

@end

@implementation ExportTranscriptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ref = [[FIRDatabase database] reference];
    listClass = [[NSMutableArray alloc] init];
    listSubject = [[NSMutableArray alloc] init];
    [self requestClassData];
    [self requestSubjectData];
    [self setUpView];
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
    [self setUpPickerFor:txtClass];
    // Picker subject
    pickerSubject = [[UIPickerView alloc] init];
    pickerSubject.delegate = self;
    pickerSubject.dataSource = self;
    [self setUpPickerFor:txtSubject];
    
}

- (void)setUpNavigation {
    self.parentViewController.navigationItem.title = @"Xuất bảng điểm môn học";
    // Right navigation button
    UIBarButtonItem *rightNavButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"arrow.up.doc"] style:UIBarButtonItemStylePlain target:self action:@selector(exportTranscript)];
    self.parentViewController.navigationItem.rightBarButtonItem = rightNavButton;
}

// MARK: Void func
- (void)exportTranscript {
    
}

// MARK: Request data
- (void)requestClassData {
    [Utils.shared startIndicator:self.view];
    [[ref child:@"class"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *classSnap;
        while (classSnap = [children nextObject]) {
            Classs *class = [[Classs alloc] initWithName:classSnap.value[@"name"] numberOfStudents:(int)classSnap.value[@"numberOfStudents"]];
            [self->listClass addObject:class];
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

// MARK: Set up picker
- (void)setUpPickerFor: (UITextField *)textField {
    //Add ToolBar on Picker
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleDefault;
    [toolbar sizeToFit];
    [pickerClass selectRow:0 inComponent:0 animated:YES];
    textField.inputAccessoryView = toolbar;
    if (textField == txtClass) {
        textField.inputView = pickerClass;
    } else if (textField == txtSubject) {
        textField.inputView = pickerSubject;
    }
    toolbar.items = @[
        [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target: nil action: nil],
        [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(tapDonePicker)]
    ];
}

-(void)tapDonePicker {
    //    NSInteger row = [pickerClass selectedRowInComponent:0];
    //    txtClass.text = listClass[row].name;
    
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
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == pickerClass) {
        return listClass[row].name;
    } else if (pickerView == pickerSubject) {
        return listSubject[row];
    }
    
    return @"N/A";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //Did end scroll will select
    if (pickerView == pickerClass) {
        txtClass.text = listClass[row].name;
    } else if (pickerView == pickerSubject) {
        txtSubject.text = listSubject[row];
    }
}

@end
