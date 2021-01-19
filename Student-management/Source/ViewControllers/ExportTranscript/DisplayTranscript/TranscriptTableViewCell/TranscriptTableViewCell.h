//
//  TranscriptTableViewCell.h
//  Student-management
//
//  Created by Dang Quoc Huy on 1/19/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TranscriptModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TranscriptTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblNum;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lbl15Score;
@property (weak, nonatomic) IBOutlet UILabel *lbl45Score;
@property (weak, nonatomic) IBOutlet UILabel *lblFinalScore;

// Function
- (void)configureCellWith:(TranscriptModel*)transcriptModel numericalOrder:(int)numericalOrder;

@end

NS_ASSUME_NONNULL_END
