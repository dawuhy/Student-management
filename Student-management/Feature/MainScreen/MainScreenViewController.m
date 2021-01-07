//
//  MainViewController.m
//  Student-management
//
//  Created by Dang Quoc Huy on 10/14/20.
//  Copyright © 2020 Dang Quoc Huy. All rights reserved.
//

#import "MainScreenViewController.h"

@interface MainScreenViewController ()

@end

@implementation MainScreenViewController
NSMutableArray *dataStudent;
NSMutableArray *dataClass;

NSMutableArray *filteredData;
BOOL isFiltered = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    
    
    filteredData = dataStudent;
}

- (void)viewWillAppear:(BOOL)animated {
    [dataStudent removeAllObjects];
    [dataClass removeAllObjects];
    [self requestStudentData];
    [self requestClassData];
}

// MARK:- Void function
-(void)setUpView {
    self.navigationItem.title = @"Danh sách";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    self.ref = [[FIRDatabase database] reference];
    
    dataStudent = [[NSMutableArray alloc] init];
    dataClass = [[NSMutableArray alloc] init];
    UINib *nibStudentCell = [UINib nibWithNibName:@"StudentCell" bundle:nil];
    [self.tableView registerNib:nibStudentCell forCellReuseIdentifier:@"StudentCell"];
}

-(void) requestStudentData {
    [[_ref child:@"student"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *studentSnap;
        while (studentSnap = [children nextObject]) {
            Student *student = [[Student alloc] initWithName:studentSnap.value[@"name"] email:studentSnap.value[@"email"] dateOfBirth:studentSnap.value[@"dateOfBirth"] gender:studentSnap.value[@"gender"] avatarURLString:studentSnap.value[@"avatarURL"] numberPhone:studentSnap.value[@"numberPhone"] class:studentSnap.value[@"class"]];
            [dataStudent addObject:student];
            [self.tableView reloadData];
        }
    }];
}

-(void) requestClassData {
    [[_ref child:@"class"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *classSnap;
        while (classSnap = [children nextObject]) {
            NSString *className = classSnap.key;
            [dataClass addObject:className];
            [self.tableView reloadData];
        }
    }];
}

//MARK:- IBAction
- (IBAction)segmentSelected:(id)sender {
    switch (_segmentOutlet.selectedSegmentIndex) {
        case 0:
            filteredData = dataStudent;
            [self.tableView reloadData];
            break;
        case 1:
            filteredData = dataClass;
            [self.tableView reloadData];
            break;
        default:
            break;
    }
}

- (IBAction)addButtonTapped:(id)sender {
    if (self.segmentOutlet.selectedSegmentIndex == 0) {
        AddStudentViewController *addStudentViewController = [[AddStudentViewController alloc] initWithNibName:@"AddStudentViewController" bundle:nil];
        [self.navigationController pushViewController:addStudentViewController animated:true];
    } else if (self.segmentOutlet.selectedSegmentIndex == 1) {
        AddClassViewController *addClassViewController = [[AddClassViewController alloc] initWithNibName:@"AddClassViewController" bundle:nil];
        [self.navigationController pushViewController:addClassViewController animated:true];
    }
}

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

// MARK:- Configure tableview
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    StudentCell *studentCell;
    if (_segmentOutlet.selectedSegmentIndex == 0) {
        studentCell = [_tableView dequeueReusableCellWithIdentifier:@"StudentCell" forIndexPath:indexPath];
        [studentCell configureWithStudentObject:filteredData[indexPath.row]];
    } else {
        studentCell = [self.tableView dequeueReusableCellWithIdentifier:@"StudentCell" forIndexPath:indexPath];
        [studentCell configureWithClassName:filteredData[indexPath.row]];
    }
    
    return studentCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [filteredData count];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [filteredData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    switch (_segmentOutlet.selectedSegmentIndex) {
        case 0:
            filteredData = [[NSMutableArray alloc] init];
            if (searchText.length == 0) {
                filteredData = dataStudent;
            } else {
                for (Student *student in dataStudent) {
                    NSRange nameRange = [student.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (nameRange.location != NSNotFound) {
                        [filteredData addObject:student];
                    }
                }
            }
            [self.tableView reloadData];
            break;
        case 1:
            filteredData = [[NSMutableArray alloc] init];
            if (searchText.length == 0) {
                filteredData = dataClass;
            } else {
                for (NSString *className in dataClass) {
                    NSRange nameRange = [className rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (nameRange.location != NSNotFound) {
                        [filteredData addObject:className];
                    }
                }
            }
            [self.tableView reloadData];
        default:
            break;
    }
}

@end
