//
//  Student.m
//  Student-management
//
//  Created by Dang Quoc Huy on 10/21/20.
//  Copyright © 2020 Dang Quoc Huy. All rights reserved.
//

#import "Student.h"

@implementation Student

-(id) initWithName: (NSString*)name email:(NSString*)email dateOfBirth:(NSString*)dateOfBirth gender:(NSString*)gender avatarURLString:(NSString*)avatarURLString numberPhone:(NSString*)numberPhone class:(NSString*)class {
    self.name = name;
    self.email = email;
    self.dateOfBirth = dateOfBirth;
    self.gender = gender;
    self.avatarURLString = avatarURLString;
    self.numberPhone = numberPhone;
    self.classs = class;
    
    return self;
}

@end
