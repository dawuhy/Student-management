//
//  ReportSubjectViewController.h
//  Student-management
//
//  Created by Dang Quoc Huy on 1/17/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FIRDatabase.h>
#import "StatisticalModel.h"
#import "DisplayTranscriptViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReportSubjectViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate> {
    
    __weak IBOutlet UIStackView *stackView;
    __weak IBOutlet UITextField *txtSubject;
    __weak IBOutlet UITextField *txtSemester;
    UIPickerView *pickerSubject;
    UIPickerView *pickerSemester;
    
    FIRDatabaseReference *ref;
    NSMutableArray<NSString*> *listSubject;
    NSMutableArray<NSString*> *listSemester;
    NSMutableArray<StatisticalModel*> *listStatistical;
}

@end

NS_ASSUME_NONNULL_END
