//
//  LEDEditTableViewQRCell.m
//  BLE-LED
//
//  Created by xlliu on 14-9-25.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "LEDEditInfoView.h"

@implementation LEDEditInfoView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _qrImageView = [UIImageView new];
        [self addSubview:_qrImageView];
        
        _qrString = [UILabel new];
        _qrString.numberOfLines = 0;
        [self addSubview:_qrString];
        
        _qrString.translatesAutoresizingMaskIntoConstraints = NO;
        _qrImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *vs = NSDictionaryOfVariableBindings(_qrString,_qrImageView);
        
        CGFloat maxHeight = MIN(frame.size.width, frame.size.height) - 40;
        NSDictionary *ms = @{@"maxHeight":@(maxHeight),
                             @"width":@(frame.size.width)};
        
        //h=w
        [_qrImageView addConstraint:
         [NSLayoutConstraint
          constraintWithItem:_qrImageView
          attribute:NSLayoutAttributeHeight
          relatedBy:NSLayoutRelationEqual
          toItem:_qrImageView
          attribute:NSLayoutAttributeWidth
          multiplier:1 constant:0]];
        
        [_qrImageView.superview addConstraint:
         [NSLayoutConstraint
          constraintWithItem:_qrImageView.superview
          attribute:NSLayoutAttributeCenterX
          relatedBy:NSLayoutRelationEqual
          toItem:_qrImageView
          attribute:NSLayoutAttributeCenterX
          multiplier:1 constant:0]];
        
//        [_qrImageView.superview addConstraints:
//         [NSLayoutConstraint
//          constraintsWithVisualFormat:@"H:|-[_qrImageView]-|"
//          options:0 metrics:nil views:vs]];
        
        [_qrString.superview addConstraint:
         [NSLayoutConstraint
          constraintWithItem:_qrString.superview
          attribute:NSLayoutAttributeCenterX
          relatedBy:NSLayoutRelationEqual
          toItem:_qrString
          attribute:NSLayoutAttributeCenterX
          multiplier:1 constant:0]];
        
        [_qrString.superview addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-[_qrString(<=width)]-|"
          options:0 metrics:ms views:vs]];


        
        [_qrImageView.superview addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|-[_qrImageView(<=maxHeight)][_qrString]-|"
          options:0 metrics:ms views:vs]];
        
        
        
//        [self addConstraints:
//         [NSLayoutConstraint
//          constraintsWithVisualFormat:@"V:|-[_qrImageView]-|"
//          options:0 metrics:nil views:vs]];
        
        
        
        //        [_qrImageView addConstraint:
        //         [NSLayoutConstraint
        //          constraintWithItem:_qrImageView
        //          attribute:NSLayoutAttributeCenterX
        //          relatedBy:NSLayoutRelationEqual
        //          toItem:_qrImageView.superview
        //          attribute:NSLayoutAttributeCenterX
        //          multiplier:1 constant:0]];
        //
        //
        //        [self.contentView addConstraints:
        //         [NSLayoutConstraint
        //          constraintsWithVisualFormat:@"H:|[_label(60)][_slider]|"
        //          options:0 metrics:nil views:vs]];
        //        [self.contentView addConstraints:
        //         [NSLayoutConstraint
        //          constraintsWithVisualFormat:@"V:|[_label]|"
        //          options:0 metrics:nil views:vs]];
        //        [self.contentView addConstraints:
        //         [NSLayoutConstraint
        //          constraintsWithVisualFormat:@"V:|[_slider]|"
        //          options:0 metrics:nil views:vs]];
        //
        //        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;

}




@end
