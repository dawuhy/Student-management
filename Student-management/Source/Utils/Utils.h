//
//  Utils.h
//  Student-management
//
//  Created by Dang Quoc Huy on 1/17/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WaitSpinner.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject {
    UIActivityIndicatorView *spinner;
    UIView *spinnerView;
}

+ (Utils *)shared;

- (void)showAlertWithTitle: (NSString *)title message: (NSString *)message titleOk: (NSString *)titleOk callbackAction: (void (^)(UIAlertAction*))callbackOk;
- (void)showAlertInteractWith: (NSString *)title message: (NSString *)message titleOk: (NSString *)titleOk callbackAction: (void (^)(UIAlertAction*))callbackOk titleCancel: (NSString *)titleCancel callbackCancel: (void (^)(UIAlertAction*))callbackCancel;
- (void)startIndicator:(UIView *)view;
- (void)stopIndicator;

@end

NS_ASSUME_NONNULL_END
