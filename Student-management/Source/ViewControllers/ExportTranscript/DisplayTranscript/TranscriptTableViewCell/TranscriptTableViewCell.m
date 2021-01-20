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

- (void)configureCellWithTranscriptModel:(TranscriptModel*)transcriptModel numericalOrder:(int)numericalOrder {
    self.lblNum.text = [NSString stringWithFormat:@"%d", numericalOrder];
    self.lblName.text = transcriptModel.studentName;
    self.lbl15Score.text = [NSString stringWithFormat:@"%.1f", transcriptModel.fifteenScore];
    self.lbl45Score.text = [NSString stringWithFormat:@"%.1f", transcriptModel.fourteenScore ];
    self.lblFinalScore.text = [NSString stringWithFormat:@"%.1f", transcriptModel.finalScore];
}

- (void)configureCellWithStatisticalModel:(StatisticalModel*)statisticalModel numericalOrder:(int)numericalOrder {
    self.lblNum.text = [NSString stringWithFormat:@"%d", numericalOrder];
    self.lblName.text = statisticalModel.className;
    self.lbl15Score.text = [NSString stringWithFormat:@"%d", statisticalModel.numberOfStudents];
    self.lbl45Score.text = [NSString stringWithFormat:@"%d", statisticalModel.numberStudentsPassing];
    self.lblFinalScore.text = [NSString stringWithFormat:@"%.0f%%", (double)statisticalModel.numberStudentsPassing/statisticalModel.numberOfStudents*100];
}

@end
