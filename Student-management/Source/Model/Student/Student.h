//
//  Student.h
//  Student-management
//
//  Created by Dang Quoc Huy on 10/21/20.
//  Copyright © 2020 Dang Quoc Huy. All rights reserved.
//

#ifndef Student_h
#define Student_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Student : NSObject

@property NSString* name;
@property NSString* email;
@property NSString* dateOfBirth;
@property NSString* gender;
@property NSString* avatarURLString;
@property NSString* numberPhone;
@property NSString* classs;
@property UIImage* avatar;

-(id) initWithName: (NSString*)name email:(NSString*)email dateOfBirth:(NSString*)dateOfBirth gender:(NSNumber*)gender avatarURLString:(NSString*)avatarURLString numberPhone:(NSString*)numberPhone class:(NSString*)class;

@end

#endif /* Student_h */
