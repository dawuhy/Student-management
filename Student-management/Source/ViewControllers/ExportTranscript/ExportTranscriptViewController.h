//
//  ExportTranscriptViewController.h
//  Student-management
//
//  Created by Dang Quoc Huy on 1/8/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FirebaseDatabase.h>
#import "Classs.h"
#import "Utils.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExportTranscriptViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate> {
    __weak IBOutlet UITextField *txtClass;
    __weak IBOutlet UITextField *txtSubject;
    __weak IBOutlet UITextField *txtSemester;
    UIPickerView *pickerClass;
    UIPickerView *pickerSubject;
    
    FIRDatabaseReference *ref;
    NSMutableArray<Classs*> *listClass;
    NSMutableArray<NSString*> *listSubject;
}

@end

NS_ASSUME_NONNULL_END
