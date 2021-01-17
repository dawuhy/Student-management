//
//  AddClassViewController.h
//  Student-management
//
//  Created by Dang Quoc Huy on 10/16/20.
//  Copyright © 2020 Dang Quoc Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FirebaseDatabase.h>
#import "Utils.h"
#import <WaitSpinner.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddClassViewController : UIViewController {
    FIRDatabaseReference *ref;
    UITextField *classTextField;
    WaitSpinner* spinner;
}

//@property (weak, nonatomic) IBOutlet UITextField *classTextField;
//@property (strong, nonatomic) FirebaseService *firebase;

@end

NS_ASSUME_NONNULL_END
