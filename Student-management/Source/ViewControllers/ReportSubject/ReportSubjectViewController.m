//
//  ReportSubjectViewController.m
//  Student-management
//
//  Created by Dang Quoc Huy on 1/17/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import "ReportSubjectViewController.h"
#import "Utils.h"

@interface ReportSubjectViewController ()

@end

@implementation ReportSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpVariable];
    [self setUpView];
    [self requestSubjectData];
    [self requestSemesterData];
    [self reloadPicker];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setUpNavigation];
}

// MARK: Set up
- (void)setUpView {
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
    // Add arrow down
    [self addArrowDownForTextField:txtSemester];
    [self addArrowDownForTextField:txtSubject];
}

- (void)setUpNavigation {
    self.parentViewController.navigationItem.title = @"Báo cáo tổng kết môn";
    // Right navigation button
    UIBarButtonItem *rightNavButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"arrow.up.doc"] style:UIBarButtonItemStylePlain target:self action:@selector(reportSubject)];
    self.parentViewController.navigationItem.rightBarButtonItem = rightNavButton;
}

- (void)setUpVariable {
    ref = [[FIRDatabase database] reference];
    listSubject = [[NSMutableArray alloc] init];
    listSemester = [[NSMutableArray alloc] init];
    listStatistical = [[NSMutableArray alloc] init];
}

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

// MARK: Void func
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

- (void)tapDonePicker {
    [self.view endEditing:YES];
}

- (void)reloadPicker {
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

- (void)reportSubject {
    [self requestResultData];
}

// MARK: Request data
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

- (void)requestResultData {
    [Utils.shared startIndicator:self.view];
    [[ref child:@"statistical"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *statisticalSnapShot;
        while (statisticalSnapShot = [children nextObject]) {
            StatisticalModel *statisticalModel = [[StatisticalModel alloc] initWithSnapShot:statisticalSnapShot];
            [self->listStatistical addObject:statisticalModel];
        }
        DisplayTranscriptViewController *displayTranscriptViewController = [[DisplayTranscriptViewController alloc] initWithNibName:@"DisplayTranscriptViewController" bundle:nil];
        displayTranscriptViewController.listStatistical = [[NSMutableArray alloc] init];
        displayTranscriptViewController.listStatistical = self->listStatistical;
        [self presentViewController:displayTranscriptViewController animated:YES completion:nil];
        [Utils.shared stopIndicator];
    }];
}

// MARK: Picker delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == pickerSubject) {
        return listSubject.count;
    } else if (pickerView == pickerSemester) {
        return listSemester.count;
    }
    
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == pickerSubject) {
        return listSubject[row];
    } else if (pickerView == pickerSemester) {
        return listSemester[row];
    }
    
    return @"N/A";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //Did end scroll will select
    if (pickerView == pickerSubject) {
        txtSubject.text = listSubject[row];
    } else if (pickerView == pickerSemester) {
        txtSemester.text = listSemester[row];
    }
}

// MARK: Text field delegate


@end
