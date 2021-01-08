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
#import "User.h"

@interface FirebaseService : NSObject

@property (strong, nonatomic) FIRDatabaseReference *ref;

// Add user to firebase
-(void)addUserWithUserName: (NSString*)userName password:(NSString*)password email:(NSString*)email dateOfBirth:(NSString*)dateOfBirth numberPhone:(NSString*)numberPhone;
// Add student to firebase
- (void)addStudentWithName: (NSString*)name email:(NSString*)email class:(NSString*)class dateOfBirth:(NSString*)dateOfBirth gender:(NSNumber*)gender numberPhone:(NSString*)numberPhone avatarURL:(NSString*)avatarURL address:(NSString*)address;
- (void)addStudentWithDict: (NSDictionary*)studentDict;
// Add class to firebase
-(void) addClassWithName: (NSString*)name;
// Authenticate login
-(BOOL) authenticateWithUserName: (NSString*)userName andPassword:(NSString*)password;

@end

#endif /* FirebaseService_h */
