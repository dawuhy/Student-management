//
//  Class.h
//  Student-management
//
//  Created by Dang Quoc Huy on 1/8/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Classs : NSObject

@property NSString* name;
@property int numberOfStudents;

- (instancetype)initWithName:(NSString*)name numberOfStudents:(int)numberOfStudents;

@end

NS_ASSUME_NONNULL_END
