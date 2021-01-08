//
//  Class.m
//  Student-management
//
//  Created by Dang Quoc Huy on 1/8/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import "Classs.h"

@implementation Classs

- (instancetype)initWithName:(NSString*)name numberOfStudents:(int)numberOfStudents {
    self.name = name;
    self.numberOfStudents = numberOfStudents;
    
    return self;
}

@end
