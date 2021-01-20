//
//  DisplayTranscriptViewController.h
//  Student-management
//
//  Created by Dang Quoc Huy on 1/19/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TranscriptModel.h"
#import "StatisticalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DisplayTranscriptViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    __weak IBOutlet UITableView *tableViewTranscript;
}

@property NSMutableArray<TranscriptModel*> *listTranscript;
@property NSMutableArray<StatisticalModel*> *listStatistical;

@end

NS_ASSUME_NONNULL_END
