//
//  LEDEditTableHeader.m
//  BLE-LED
//
//  Created by xlliu on 14-9-24.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "LEDEditTableHeader.h"

@implementation LEDEditTableHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
         _label = [UILabel new];
        [self.contentView addSubview:_label];
        
        _accessoryView = [UIControl new];
        [self.contentView addSubview:_accessoryView];
        
        
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _accessoryView.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *vs = NSDictionaryOfVariableBindings(_label,_accessoryView);
        
        [self.contentView addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:
          @"H:|-[_label]->=5@100-[_accessoryView(50)]-|"
          options:0 metrics:nil views:vs]];
        [self.contentView addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:
          @"V:|[_label]|"
          options:0 metrics:nil views:vs]];
        [self.contentView addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:
          @"V:|[_accessoryView]|"
          options:0 metrics:nil views:vs]];
        
        [_accessoryView addTarget:self action:@selector(accessoryViewTapWithEnVent:) forControlEvents:UIControlEventAllEvents];
        
    }
    return self;
}

- (void)setAccessoryView:(UIControl *)accessoryView
{
    _accessoryView = accessoryView;
    
}

- (void)accessoryViewTapWithEnVent:(UIControlEvents *)e
{
    [self.delegate LEDEditHeader:self WithEnvent:e];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
