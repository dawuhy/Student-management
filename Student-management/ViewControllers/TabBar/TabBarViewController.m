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

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
//    MainScreenViewController *mainScreen = [[MainScreenViewController alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainScreen" bundle:nil];
    MainScreenViewController *mainScreenViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainScreenViewController"];
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage systemImageNamed:@"house"] selectedImage:[UIImage systemImageNamed:@"house.fill"]];
    mainScreenViewController.tabBarItem = tabBarItem;
    
    UserInfoViewController *userInfoViewController = [[UserInfoViewController alloc] init];
    tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Account" image:[UIImage systemImageNamed:@"person"] selectedImage:[UIImage systemImageNamed:@"person.fill"]];
    userInfoViewController.tabBarItem = tabBarItem;
    
//    self.viewControllers = [NSArray arrayWithObjects:navMainScreen, nil];
    self.viewControllers = @[mainScreenViewController, userInfoViewController];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
