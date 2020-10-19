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
    _ref = [[FIRDatabase database] reference];
    return self;
}

-(void)addUserWithUserName: (NSString*)userName password:(NSString*)password email:(NSString*)email dateOfBirth:(NSString*)dateOfBirth numberPhone:(NSString*)numberPhone {
    
    NSDictionary<NSString*, id> *dic = @{ @"userName": userName,
                                          @"password": password,
                                          @"email": email,
                                          @"dateOfBirth": dateOfBirth,
                                          @"numberPhone": numberPhone };
    
    [[[_ref child:@"user"] childByAutoId] setValue:dic withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            printf("Error");
        } else {
            printf("Success");
        }
    }];
}

-(void)addStudentWithName: (NSString*)name email:(NSString*)email class:(NSString*)class dateOfBirth:(NSString*)dateOfBirth numberPhone:(NSString*)numberPhone {
    
    NSDictionary<NSString*, id> *dic = @{ @"name" : name, @"email" : email, @"class": class, @"dateOfBirth": dateOfBirth, @"numberPhone": numberPhone };
    
    [[[_ref child:@"student"] childByAutoId] setValue:dic withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            printf("Error");
        } else {
            printf("Success");
        }
    }];
}

@end
