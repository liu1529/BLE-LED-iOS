//
//  GrpEditOnOffCell.m
//  BLE-LED
//
//  Created by lxl on 14-10-15.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "GrpEditOnOffCell.h"

@implementation GrpEditOnOffCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _label = [UILabel new];
        _slider = [UISlider new];
        [_slider addTarget:self action:@selector(sliderValueChange)
          forControlEvents:UIControlEventValueChanged];
        
        
        [self.contentView addSubview:_label];
        [self.contentView addSubview:_slider];
        
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _slider.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *vd = NSDictionaryOfVariableBindings(_label,_slider);
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:self.label attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:self.slider attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_label(60)]-[_slider]|" options:0 metrics:nil views:vd]];
    }
    
    return self;
}

- (void) sliderValueChange
{
    if (![self.delegate respondsToSelector:@selector(grpEditCell:valueChangeInView:)])
        return;
    [self.delegate grpEditCell:self valueChangeInView:self.slider];
}

@end
