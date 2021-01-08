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
    
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.image = [UIImage systemImageNamed:@"person"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//- (void)configureWithStudentObject: (Student*)student {
//    self.nameLabel.text = student.name;
//    self.classLabel.text = student.classs;
////    self.avatarImageView.image = [UIImage systemImageNamed:@"person"];
//    [self loadImageFromURL:student.avatarURLString];
//}

- (void)configureWithName: (NSString*)name class:(NSString*)class avatar:(UIImage*)imgAvatar {
    self.nameLabel.text = name;
    self.classLabel.text = class;
    if (imgAvatar == nil) {
        self.avatarImageView.image = [UIImage systemImageNamed:@"person"];
    } else {
        self.avatarImageView.image = imgAvatar;
    }
}

- (void)configureWithClassName: (NSString*)className {
    self.nameLabel.text = className;
    self.classLabel.text = @"";
//    [self.imageView setHidden:true];
    self.avatarImageView.image = [UIImage imageNamed:@"class"];
}

- (void)loadImageFromURL: (NSString*)urlString {
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlString]];
        if (data == nil) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.avatarImageView.image = [UIImage imageWithData: data];
        });
    });
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.avatarImageView.image = [UIImage systemImageNamed:@"person"];
    _classLabel.text = @"Loading ...";
    _nameLabel.text = @"Loading ...";
}

@end
