//
//  StudentCell.h
//  Student-management
//
//  Created by Dang Quoc Huy on 10/21/20.
//  Copyright © 2020 Dang Quoc Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"

NS_ASSUME_NONNULL_BEGIN

@interface StudentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)configureWithStudentObject: (Student*)student;
- (void)configureWithClassName: (NSString*)className;

@end

NS_ASSUME_NONNULL_END
