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

-(void)addUserWithUserName: (NSString*)userName password:(NSString*)password email:(NSString*)email dateOfBirth:(NSString*)dateOfBirth numberPhone:(NSString*)numberPhone {
    
    NSDictionary<NSString*, id> *dic = @{ @"userName": userName,
                                          @"password": password,
                                          @"email": email,
                                          @"dateOfBirth": dateOfBirth,
                                          @"numberPhone": numberPhone };
    
    [[[self.ref child:@"user"] childByAutoId] setValue:dic];
    
//    [[[self.ref child:@"user"] childByAutoId] setValue:dic withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
//        if (error) {
//            printf("Add user fail.");
//        } else {
//            printf("Add user successfully.");
//        }
//    }];
}

- (void)addStudentWithName: (NSString*)name email:(NSString*)email class:(NSString*)class dateOfBirth:(NSString*)dateOfBirth gender:(NSNumber*)gender numberPhone:(NSString*)numberPhone avatarURL:(NSString*)avatarURL address:(NSString*)address {
    NSDictionary<NSString*, id> *dic = @{ @"name": name,
                                          @"email": email,
                                          @"class": class,
                                          @"dateOfBirth": dateOfBirth,
                                          @"gender": gender,
                                          @"numberPhone": numberPhone,
                                          @"address": address,
                                          @"avatarURL": avatarURL
    };
    [[[self.ref child:@"student"] childByAutoId] setValue:dic];
}

- (void)addStudentWithDict: (NSDictionary*)studentDict {
//    [[[self.ref child: @"student"] childByAutoId] setValue: studentDict];
    [[[self.ref child: @"student"] childByAutoId] setValue:studentDict withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error != nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataMainScreen" object:nil];
        } else {
            NSLog(@"ERROR: %@", error.localizedDescription);
        }
    }];
}

- (void)addClassWithName: (NSString*)name {
    NSDictionary<NSString*, id> *dic = @{ @"name": name };
    [[[self.ref child:@"class"] child:[NSString stringWithFormat:@"%@", name]] setValue:dic];
}

-(BOOL)authenticateWithUserName:(NSString*)userName andPassword:(NSString*)password {
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

@end
