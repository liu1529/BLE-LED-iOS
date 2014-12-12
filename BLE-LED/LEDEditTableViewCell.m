//
//  LEDEditTableViewCell.m
//  BLE-LED
//
//  Created by xlliu on 14-9-24.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "LEDEditTableViewCell.h"

@implementation LEDEditTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _label = [UILabel new];
        [self.contentView addSubview:_label];
        
        _slider = [UISlider new];
        _slider.continuous = NO;
        [self.contentView addSubview:_slider];
        
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _slider.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *vs = NSDictionaryOfVariableBindings(_label,_slider);
        
        [self.contentView addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|[_label(60)][_slider]-|"
          options:0 metrics:nil views:vs]];
        [self.contentView addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|[_label]|"
          options:0 metrics:nil views:vs]];
        [self.contentView addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|[_slider]|"
          options:0 metrics:nil views:vs]];

        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
