//
//  RegisterAccountViewController.h
//  Student-management
//
//  Created by Dang Quoc Huy on 10/14/20.
//  Copyright © 2020 Dang Quoc Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FirebaseDatabase.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignUpViewController : UIViewController {
    FIRDatabaseReference *ref;
}

//@property (strong, nonatomic) FirebaseService *firebase;

@end

NS_ASSUME_NONNULL_END
