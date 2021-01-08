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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpVariable];
    [self setUpView];
    filteredData = dataStudent;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPage) name:@"reloadPage" object:nil];
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
    self->tableView.delegate = self;
    self->tableView.dataSource = self;
    self.searchBar.delegate = self;
    self.ref = [[FIRDatabase database] reference];
    
    UINib *nibStudentCell = [UINib nibWithNibName:@"StudentCell" bundle:nil];
    [self->tableView registerNib:nibStudentCell forCellReuseIdentifier:@"StudentCell"];
    
    // Left navigation button
    UIBarButtonItem *leftNavButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"arrowshape.turn.up.left"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTapped)];
    self.parentViewController.navigationItem.leftBarButtonItem = leftNavButton;
    
    // Right navigation button
    UIBarButtonItem *rightNavButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus"] style:UIBarButtonItemStylePlain target:self action:@selector(addButtonTapped)];
    self.parentViewController.navigationItem.rightBarButtonItem = rightNavButton;
}

- (void)setUpVariable {
    isFiltered = false;
    dataStudent = [[NSMutableArray alloc] init];
    dataClass = [[NSMutableArray alloc] init];
}

- (void)reloadPage {
    [self->tableView reloadData];
}

// MARK: - Networking
-(void) requestStudentData {
    [[_ref child:@"student"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *studentSnap;
        while (studentSnap = [children nextObject]) {
            Student *student = [[Student alloc] initWithName:studentSnap.value[@"name"] email:studentSnap.value[@"email"] dateOfBirth:studentSnap.value[@"dateOfBirth"] gender:studentSnap.value[@"gender"] avatarURLString:studentSnap.value[@"avatarURL"] numberPhone:studentSnap.value[@"numberPhone"] class:studentSnap.value[@"class"]];
            [self->dataStudent addObject:student];
            [self->tableView reloadData];
        }
    }];
}

-(void) requestClassData {
    [[_ref child:@"class"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *classSnap;
        while (classSnap = [children nextObject]) {
//            NSString *className = classSnap.key;
//            [self->dataClass addObject:className];
//            [self->tableView reloadData];
            Classs *class = [[Classs alloc] initWithName:classSnap.value[@"name"] numberOfStudents:(int)classSnap.value[@"numberOfStudents"]];
            [self->dataClass addObject:class];
            [self->tableView reloadData];
        }
    }];
}

//MARK:- Actions
- (IBAction)segmentSelected:(id)sender {
    switch (_segmentOutlet.selectedSegmentIndex) {
        case 0:
            filteredData = dataStudent;
            [self->tableView reloadData];
            break;
        case 1:
            filteredData = dataClass;
            [self->tableView reloadData];
            break;
        default:
            break;
    }
}

- (void)addButtonTapped {
    if (self.segmentOutlet.selectedSegmentIndex == 0) {
        AddStudentViewController *addStudentViewController = [[AddStudentViewController alloc] initWithNibName:@"AddStudentViewController" bundle:nil];
        addStudentViewController.listClass = [[NSMutableArray alloc] init];
        addStudentViewController.listClass = dataClass;
        [self.navigationController pushViewController:addStudentViewController animated:true];
    } else if (self.segmentOutlet.selectedSegmentIndex == 1) {
        AddClassViewController *addClassViewController = [[AddClassViewController alloc] initWithNibName:@"AddClassViewController" bundle:nil];
        [self.navigationController pushViewController:addClassViewController animated:true];
    }
}

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:true];
}



// MARK: - Table view delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    StudentCell *studentCell;
    if (_segmentOutlet.selectedSegmentIndex == 0) {
        studentCell = [self->tableView dequeueReusableCellWithIdentifier:@"StudentCell" forIndexPath:indexPath];
//        [studentCell configureWithStudentObject:filteredData[indexPath.row]];
        NSArray<Student*> *data= filteredData;
        [studentCell configureWithName:data[indexPath.row].name class:data[indexPath.row].classs avatar:data[indexPath.row].avatar];
    } else {
        studentCell = [self->tableView dequeueReusableCellWithIdentifier:@"StudentCell" forIndexPath:indexPath];
        NSArray<Classs*> *data= filteredData;
        [studentCell configureWithClassName:data[indexPath.row].name];
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

// MARK: - Search bar delegate
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
            [self->tableView reloadData];
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
            [self->tableView reloadData];
        default:
            break;
    }
}

@end
