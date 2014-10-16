//
//  GrpEditLedsCell.m
//  BLE-LED
//
//  Created by lxl on 14-10-15.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "GrpEditLedsCell.h"

@implementation GrpEditLedsCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [UILabel new];
        _imageView = [UIImageView new];
        _label.numberOfLines = 0;
        
        
        [self.contentView addSubview:_label];
        [self.contentView addSubview:_imageView];
        
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *vd = NSDictionaryOfVariableBindings(_label,_imageView);
        
        [self.imageView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:0 toItem:self.imageView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:self.label attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:self.imageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView][_label(>=20)]|" options:0 metrics:nil views:vd]];
        
        
        //选择后，为灰色背景
        UIView *selectView = [[UIView alloc] initWithFrame:self.frame];
        selectView.backgroundColor = [UIColor grayColor];
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select.png"]];
        iv.translatesAutoresizingMaskIntoConstraints = NO;
        [selectView addSubview:iv];
        
        [selectView addConstraint:
         [NSLayoutConstraint
          constraintWithItem:selectView
          attribute:NSLayoutAttributeBottom
          relatedBy:0
          toItem:iv
          attribute:NSLayoutAttributeBottom
          multiplier:1 constant:0]];
        
        [selectView addConstraint:
         [NSLayoutConstraint
          constraintWithItem:selectView
          attribute:NSLayoutAttributeTrailing
          relatedBy:0
          toItem:iv
          attribute:NSLayoutAttributeTrailing
          multiplier:1 constant:0]];
        
        [iv addConstraint:
         [NSLayoutConstraint
          constraintWithItem:iv
          attribute:NSLayoutAttributeWidth
          relatedBy:0
          toItem:nil
          attribute:NSLayoutAttributeNotAnAttribute
          multiplier:0 constant:20]];
        
        [iv addConstraint:
         [NSLayoutConstraint
          constraintWithItem:iv
          attribute:NSLayoutAttributeHeight
          relatedBy:0
          toItem:nil
          attribute:NSLayoutAttributeNotAnAttribute
          multiplier:0 constant:20]];
        
        
        self.selectedBackgroundView = selectView;
        

    }
    return self;
}

@end
