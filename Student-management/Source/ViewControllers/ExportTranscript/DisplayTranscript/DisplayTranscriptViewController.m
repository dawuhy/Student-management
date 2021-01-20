//
//  DisplayTranscriptViewController.m
//  Student-management
//
//  Created by Dang Quoc Huy on 1/19/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import "DisplayTranscriptViewController.h"
#import "TranscriptTableViewCell.h"

@interface DisplayTranscriptViewController ()
@end

@implementation DisplayTranscriptViewController
@synthesize listTranscript;
@synthesize listStatistical;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpVariable];
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

// MARK: Set up
- (void)setUpView {
    tableViewTranscript.delegate = self;
    tableViewTranscript.dataSource = self;
    
    //    let nibMovieCell = UINib(nibName: MovieCell.identifier, bundle: nil)
    //    movieCollectionView.register(nibMovieCell, forCellWithReuseIdentifier: MovieCell.identifier)
    UINib *nib = [UINib nibWithNibName:@"TranscriptTableViewCell" bundle:nil];
    [tableViewTranscript registerNib:nib forCellReuseIdentifier:@"TranscriptTableViewCell"];
}

- (void)setUpVariable {
    
}

- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// MARK: Table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (listTranscript) {
        return listTranscript.count;
    } else {
        return listStatistical.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TranscriptTableViewCell *transcriptTableViewCell = [tableViewTranscript dequeueReusableCellWithIdentifier:@"TranscriptTableViewCell" forIndexPath:indexPath];
    
    if (listTranscript) {
        [transcriptTableViewCell configureCellWithTranscriptModel:listTranscript[indexPath.row] numericalOrder:(int)indexPath.row+1];
    } else {
        [transcriptTableViewCell configureCellWithStatisticalModel:listStatistical[indexPath.row] numericalOrder:(int)indexPath.row+1];
    }
    
    
    return transcriptTableViewCell;
    
}

@end
