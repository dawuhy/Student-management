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


@interface FirebaseService : NSObject

-(void)writeData: (NSString*)name;

@end

#endif /* FirebaseService_h */
