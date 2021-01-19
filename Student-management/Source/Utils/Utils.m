//
//  Utils.m
//  Student-management
//
//  Created by Dang Quoc Huy on 1/17/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+ (Utils *)shared {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    
    return instance;
}

// MARK: Alert
// Show Alert With Message Inform
- (void)showAlertWithTitle: (NSString *)title message: (NSString *)message titleOk: (NSString *)titleOk callbackAction: (void (^)(UIAlertAction*))callbackOk {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle: title
                                 message: message
                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction* btnOk = [UIAlertAction
                                actionWithTitle: titleOk
                                style: UIAlertActionStyleDefault
                                handler: callbackOk];
    
    
    [alert addAction: btnOk];
    UIViewController *root = [self getTopViewController];
    [root presentViewController: alert animated: YES completion: nil];
}

// Show Alert With Message + Action
- (void)showAlertInteractWith: (NSString *)title message: (NSString *)message titleOk: (NSString *)titleOk callbackAction: (void (^)(UIAlertAction*))callbackOk titleCancel: (NSString *)titleCancel callbackCancel: (void (^)(UIAlertAction*))callbackCancel {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle: title
                                 message: message
                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction* btnOk = [UIAlertAction
                                actionWithTitle: titleOk
                                style: UIAlertActionStyleDefault
                                handler: callbackOk];
    
    UIAlertAction* btnCancel = [UIAlertAction
                                actionWithTitle: titleCancel
                                style: UIAlertActionStyleCancel
                                handler: callbackCancel];
    
    [alert addAction: btnOk];
    [alert addAction: btnCancel];
    UIViewController *root = [self getTopViewController];
    [root presentViewController: alert animated: YES completion: nil];
}

- (UIViewController *)getTopViewController {
    UIViewController *topController = [UIApplication sharedApplication].windows[0].rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

// MARK: Spinner
- (void)startIndicator:(UIView *)view {
    spinnerView = view;
    if (!spinner) {
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        CGRect rect = [spinnerView bounds];
        spinner.center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
        spinner.hidesWhenStopped = YES;
    }
    
    [spinnerView setUserInteractionEnabled:NO];
    [spinnerView addSubview:spinner];
    [spinner startAnimating];
}

- (void)stopIndicator {
    [spinnerView setUserInteractionEnabled:YES];
    [spinnerView setNeedsDisplay];
    [spinner stopAnimating];
}

@end
