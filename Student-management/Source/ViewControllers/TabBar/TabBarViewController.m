//
//  TabBarViewController.m
//  Student-management
//
//  Created by Dang Quoc Huy on 1/8/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import "TabBarViewController.h"
#import "MainScreenViewController.h"
#import "UserInfoViewController.h"
#import "ExportTranscriptViewController.h"
#import "ReportSubjectViewController.h"

@interface TabBarViewController () <UITabBarDelegate>

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    // Item 1
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainScreen" bundle:nil];
    MainScreenViewController *mainScreenViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainScreenViewController"];
    UITabBarItem *tabBarMainScreen= [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage systemImageNamed:@"house"] selectedImage:[UIImage systemImageNamed:@"house.fill"]];
    mainScreenViewController.tabBarItem = tabBarMainScreen;
    // Item 2
    ExportTranscriptViewController *exportTranscriptViewController = [[ExportTranscriptViewController alloc] init];
    UITabBarItem *tabBarExportTranscript = [[UITabBarItem alloc] initWithTitle:@"Export transcript" image:[UIImage systemImageNamed:@"arrow.up.doc"] selectedImage:[UIImage systemImageNamed:@"arrow.up.doc.fill"]];
    exportTranscriptViewController.tabBarItem = tabBarExportTranscript;
    // Item 3
    ReportSubjectViewController *reportSubjectViewController = [[ReportSubjectViewController alloc] init];
    UITabBarItem *tabBarReportSubject = [[UITabBarItem alloc] initWithTitle:@"Report subject" image:[UIImage systemImageNamed:@"chart.bar.doc.horizontal"] selectedImage:[UIImage systemImageNamed:@"chart.bar.doc.horizontal.fill"]];
    reportSubjectViewController.tabBarItem = tabBarReportSubject;
    // Item 4
    UserInfoViewController *userInfoViewController = [[UserInfoViewController alloc] init];
    UITabBarItem *tabBarUserInfo = [[UITabBarItem alloc] initWithTitle:@"Account" image:[UIImage systemImageNamed:@"person"] selectedImage:[UIImage systemImageNamed:@"person.fill"]];
    userInfoViewController.tabBarItem = tabBarUserInfo;
    
    self.viewControllers = @[mainScreenViewController,
                             exportTranscriptViewController,
                             reportSubjectViewController,
                             userInfoViewController,
                             ];
    
    
}

// MARK: - Tabbar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
}
@end
