//
//  FirebaseService.m
//  Student-management
//
//  Created by Dang Quoc Huy on 10/16/20.
//  Copyright © 2020 Dang Quoc Huy. All rights reserved.
//

#import "FirebaseService.h"

@interface FirebaseService ()

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation FirebaseService

-(id)init {
    self.ref = [[FIRDatabase database] reference];
    return self;
}

-(void)writeData: (NSString*)name {
//    [[_ref child:@"student/name"] setValue:name];
    [[_ref child:@"student/name"] setValue:name withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            NSLog(@"Data could not be saved: %@", error);
        } else {
            NSLog(@"Data saved successfully");
        }
    }];
}

//    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    
//    _ref = [[FIRDatabase database] reference];
    
//    [[_ref child:@"someID/name"] setValue:@"Changed"];
    
//    [[_ref child:@"someID"] observeSingleEventOfType: FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        NSDictionary *name = snapshot.value;
//
//        NSLog(@"%@", name);
//    }];

@end
