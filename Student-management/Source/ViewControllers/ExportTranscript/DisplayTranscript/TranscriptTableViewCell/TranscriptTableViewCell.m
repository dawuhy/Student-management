//
//  TranscriptTableViewCell.m
//  Student-management
//
//  Created by Dang Quoc Huy on 1/19/21.
//  Copyright © 2021 Dang Quoc Huy. All rights reserved.
//

#import "TranscriptTableViewCell.h"

@implementation TranscriptTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWith:(TranscriptModel*)transcriptModel numericalOrder:(int)numericalOrder {
    NSLog(@"LOGLOG: %@", [NSString stringWithFormat:@"%f", transcriptModel.fifteenScore]);
    self.lblNum.text = [NSString stringWithFormat:@"%d", numericalOrder];
    self.lblName.text = transcriptModel.studentName;
    self.lbl15Score.text = [NSString stringWithFormat:@"%.1f", transcriptModel.fifteenScore];
    self.lbl45Score.text = [NSString stringWithFormat:@"%.1f", transcriptModel.fourteenScore ];
    self.lblFinalScore.text = [NSString stringWithFormat:@"%.1f", transcriptModel.finalScore];
}

@end
