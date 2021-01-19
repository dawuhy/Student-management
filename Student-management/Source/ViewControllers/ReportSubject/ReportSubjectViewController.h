//
//  ReportSubjectViewController.h
//  Student-management
//
//  Created by Dang Quoc Huy on 1/17/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReportSubjectViewController : UIViewController {
    
    __weak IBOutlet UIStackView *stackView;
    __weak IBOutlet UITextField *txtSubject;
    __weak IBOutlet UITextField *txtSemester;
}

@end

NS_ASSUME_NONNULL_END