//
//  TranscriptModel.h
//  Student-management
//
//  Created by Dang Quoc Huy on 1/19/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FIRDataSnapshot.h>

NS_ASSUME_NONNULL_BEGIN

@interface TranscriptModel : NSObject

@property NSString* classs;
@property double fifteenScore;
@property double finalScore;
@property double fourteenScore;
@property NSString* sesmester;
@property NSString* studentName;
@property NSString* subject;

- (instancetype)initWithStudentName:(NSString*)studentName class:(NSString*)class semester:(NSString*)semester subject:(NSString*)subject fifteenScore:(double)fifteenScore fourteenScore:(double)fourteenScore finalScore:(double)finalScore;
- (instancetype)initWithSnapShot:(FIRDataSnapshot*)snapShot;
@end

NS_ASSUME_NONNULL_END
