//
//  Utils.h
//  Student-management
//
//  Created by Dang Quoc Huy on 1/17/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject {
    
}

+ (Utils *)shared;

- (void)showAlertWithTitle: (NSString *)title message: (NSString *)message titleOk: (NSString *)titleOk callbackAction: (void (^)(UIAlertAction*))callbackOk;
- (void)showAlertInteractWith: (NSString *)title message: (NSString *)message titleOk: (NSString *)titleOk callbackAction: (void (^)(UIAlertAction*))callbackOk titleCancel: (NSString *)titleCancel callbackCancel: (void (^)(UIAlertAction*))callbackCancel;
@end

NS_ASSUME_NONNULL_END
