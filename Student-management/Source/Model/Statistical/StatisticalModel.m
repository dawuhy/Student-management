//
//  StatisticalModel.m
//  Student-management
//
//  Created by Dang Quoc Huy on 1/20/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import "StatisticalModel.h"

@implementation StatisticalModel

- (instancetype)initWithSnapShot:(FIRDataSnapshot*)snapShot {
    self.className = snapShot.value[@"className"];
    self.numberOfStudents = [snapShot.value[@"numberOfStudents"] intValue];
    self.numberStudentsPassing = [snapShot.value[@"numberOfStudents"] intValue];
    
    return self;
}

@end
