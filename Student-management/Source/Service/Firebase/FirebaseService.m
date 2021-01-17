//
//  FirebaseService.m
//  Student-management
//
//  Created by Dang Quoc Huy on 10/16/20.
//  Copyright © 2020 Dang Quoc Huy. All rights reserved.
//

#import "FirebaseService.h"

@interface FirebaseService ()
@end

@implementation FirebaseService

-(id)init {
    self.ref = [[FIRDatabase database] reference];
    return self;
}

- (void)addUserWithDict: (NSDictionary *)userDict {
    [[[self.ref child:@"user"] childByAutoId] setValue:userDict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            NSLog(@"ERROR: %@", error.localizedDescription);
        } else {
            
        }
    }];
}

- (void)addStudentWithDict: (NSDictionary*)studentDict {
    [[[self.ref child: @"student"] childByAutoId] setValue:studentDict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            NSLog(@"ERROR: %@", error.localizedDescription);
        } else {
            [Utils.shared showAlertWithTitle:@"Notification" message:@"Add student success" titleOk:@"OK" callbackAction:^(UIAlertAction * actionOK) {
                [[self getTopViewController].navigationController popViewControllerAnimated:true];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataMainScreen" object:nil];
            }];
            
        }
    }];
}

- (void)addClassWithName: (NSString*)name {
    NSDictionary<NSString*, id> *dic = @{ @"name": name };
    [[[self.ref child:@"class"] child:name] setValue:dic];
}

- (BOOL)authenticateWithUserName:(NSString*)userName andPassword:(NSString*)password {
    [[_ref child:@"user"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *userAccount;
        while (userAccount = [children nextObject]) {
            if ([userName isEqualToString:[userAccount childSnapshotForPath:@"userName"].value]
                && [password isEqualToString:[userAccount childSnapshotForPath:@"password"].value]) {
            } else {
                printf("false");
            }
        }
    }];
    return false;
}

- (UIViewController *)getTopViewController {
    UIViewController *topController = [UIApplication sharedApplication].windows[0].rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

@end
