//
//  StudentCell.m
//  Student-management
//
//  Created by Dang Quoc Huy on 10/21/20.
//  Copyright © 2020 Dang Quoc Huy. All rights reserved.
//

#import "StudentCell.h"


@implementation StudentCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)configureWithStudentObject: (Student*)student {
    self.nameLabel.text = student.name;
    self.classLabel.text = student.classs;
    [self loadImageFromURL:student.avatarURLString];
//    self.avatarImageView.image = student.avatar;
}

- (void)configureWithClassName: (NSString*)className {
    self.nameLabel.text = className;
    self.classLabel.text = @"";
    [self.imageView setHidden:true];
//    self.imageView.image = [UIImage imageNamed:@"logo"];
}

- (void) loadImageFromURL: (NSString*)urlString {
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlString]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            self.avatarImageView.image = [UIImage imageWithData: data];
        });
    });
}

- (void) prepareForReuse {
    [super prepareForReuse];
    self.nameLabel.text = @"";
    self.classLabel.text = @"";
    self.imageView.image = [[UIImage alloc] init];
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    self.nameLabel.text = @"";
    self.classLabel.text = @"";
    self.imageView.image = [[UIImage alloc] init];
}

@end
