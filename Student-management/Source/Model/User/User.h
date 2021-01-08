//
//  User.h
//  Student-management
//
//  Created by Dang Quoc Huy on 10/19/20.
//  Copyright © 2020 Dang Quoc Huy. All rights reserved.
//

#ifndef User_h
#define User_h

#import <Foundation/Foundation.h>

@interface User : NSObject

@property NSString* userName;
@property NSString* email;
@property NSString* dateOfBirth;
@property NSString* numberPhone;
@property NSString* password;

@end

#endif /* User_h */
