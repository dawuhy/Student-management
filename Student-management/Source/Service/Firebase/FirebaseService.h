//
//  FirebaseService.h
//  Student-management
//
//  Created by Dang Quoc Huy on 10/16/20.
//  Copyright © 2020 Dang Quoc Huy. All rights reserved.
//

#ifndef FirebaseService_h
#define FirebaseService_h

#import <Foundation/Foundation.h>
#import <FirebaseDatabase.h>
#import <UIKit/UIKit.h>
#import "User.h"
#import "Utils.h"

@interface FirebaseService : NSObject

@property (strong, nonatomic) FIRDatabaseReference *ref;

// Add user to firebase
//- (void)addUserWithDict: (NSDictionary *)userDict;
// Add student to firebase
//- (void)addStudentWithDict: (NSDictionary*)studentDict;
// Add class to firebase
//-(void) addClassWithName: (NSString*)name;
// Authenticate login
-(BOOL) authenticateWithUserName: (NSString*)userName andPassword:(NSString*)password;

@end

#endif /* FirebaseService_h */
