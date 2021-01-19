//
//  ReportSubjectViewController.m
//  Student-management
//
//  Created by Dang Quoc Huy on 1/17/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import "ReportSubjectViewController.h"

@interface ReportSubjectViewController ()

@end

@implementation ReportSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.parentViewController.navigationItem.title = @"Báo cáo tổng kết môn";
}

// MARK: Set up
- (void)setUpView {
    [self addArrowDownForTextField:txtSemester];
    [self addArrowDownForTextField:txtSubject];
}

// MARK: Void func
- (void)addArrowDownForTextField:(UITextField*)textField {
    UIImageView *ivArrowDown = [[UIImageView alloc] init];
    ivArrowDown.image = [UIImage systemImageNamed:@"arrowtriangle.down.fill"];
    ivArrowDown.frame = CGRectMake(textField.frame.origin.x + stackView.frame.origin.x + textField.frame.size.width - 30,
                                   textField.frame.origin.y + stackView.frame.origin.y + 12,
                                   15,
                                   8);
    ivArrowDown.tintColor = [UIColor colorWithRed:20/255.0 green:110/255.0 blue:190/255.0 alpha:1];
    
    [self.view addSubview:ivArrowDown];
}

@end
