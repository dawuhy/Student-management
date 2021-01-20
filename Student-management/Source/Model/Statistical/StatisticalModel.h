//
//  StatisticalModel.h
//  Student-management
//
//  Created by Dang Quoc Huy on 1/20/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FIRDataSnapshot.h>

NS_ASSUME_NONNULL_BEGIN

@interface StatisticalModel : NSObject
@property NSString* className;
@property int numberOfStudents;
@property int numberStudentsPassing;

- (instancetype)initWithSnapShot:(FIRDataSnapshot*)snapShot;

@end

NS_ASSUME_NONNULL_END
