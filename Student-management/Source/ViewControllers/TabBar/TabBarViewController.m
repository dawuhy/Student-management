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

@interface TabBarViewController () <UITabBarDelegate>

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainScreen" bundle:nil];
    MainScreenViewController *mainScreenViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainScreenViewController"];
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage systemImageNamed:@"house"] selectedImage:[UIImage systemImageNamed:@"house.fill"]];
    mainScreenViewController.tabBarItem = tabBarItem;
    
    UserInfoViewController *userInfoViewController = [[UserInfoViewController alloc] init];
    UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"Account" image:[UIImage systemImageNamed:@"person"] selectedImage:[UIImage systemImageNamed:@"person.fill"]];
    userInfoViewController.tabBarItem = tabBarItem2;
    
    ExportTranscriptViewController *exportTranscriptViewController = [[ExportTranscriptViewController alloc] init];
    UITabBarItem *tabBarItem3 = [[UITabBarItem alloc] initWithTitle:@"Export transcript" image:[UIImage systemImageNamed:@"arrow.up.doc"] selectedImage:[UIImage systemImageNamed:@"arrow.up.doc.fill"]];
    exportTranscriptViewController.tabBarItem = tabBarItem3;
    
    self.viewControllers = @[mainScreenViewController,
                             exportTranscriptViewController,
                             userInfoViewController,
                             ];
    
    
}

// MARK: - Tabbar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
}
@end
