//
//  MainViewController.h
//  Student-management
//
//  Created by Dang Quoc Huy on 10/14/20.
//  Copyright © 2020 Dang Quoc Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddStudentViewController.h"
#import "AddClassViewController.h"
#import "StudentCell.h"
#import "Classs.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainScreenViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    NSMutableArray<Student*> *dataStudent;
    NSMutableArray<Classs*> *dataClass;
    NSMutableArray *filteredData;
    BOOL isFiltered;
    
    __weak IBOutlet UITableView *tableView;
}

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentOutlet;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

NS_ASSUME_NONNULL_END
