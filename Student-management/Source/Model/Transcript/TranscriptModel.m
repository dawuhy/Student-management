//
//  TranscriptModel.m
//  Student-management
//
//  Created by Dang Quoc Huy on 1/19/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import "TranscriptModel.h"

@implementation TranscriptModel

- (instancetype)initWithStudentName:(NSString*)studentName class:(NSString*)class semester:(NSString*)semester subject:(NSString*)subject fifteenScore:(double)fifteenScore fourteenScore:(double)fourteenScore finalScore:(double)finalScore {
    
    self.studentName = studentName;
    self.classs = class;
    self.sesmester = semester;
    self.subject = subject;
    self.fifteenScore = fifteenScore;
    self.fourteenScore = fourteenScore;
    self.finalScore = finalScore;
    
    return self;
}

- (instancetype)initWithSnapShot:(FIRDataSnapshot*)snapShot {
    self.studentName = snapShot.value[@"studentName"];
    self.classs = snapShot.value[@"class"];
    self.sesmester = snapShot.value[@"semester"];
    self.subject = snapShot.value[@"subject"];
    self.fifteenScore = [snapShot.value[@"fifteenScore"] doubleValue];
    self.fourteenScore = [snapShot.value[@"fourteenScore"] doubleValue];
    self.finalScore = [snapShot.value[@"finalScore"] doubleValue];
    
    return self;
}

@end
