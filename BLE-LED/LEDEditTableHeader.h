//
//  LEDEditTableHeader.h
//  BLE-LED
//
//  Created by xlliu on 14-9-24.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LEDEditTableHeader;

@class LEDEditTableHeader;

@protocol LEDEditHeaderDelegae <NSObject>

- (void) LEDEditHeader:(LEDEditTableHeader *)header WithEnvent:(UIControlEvents *)event;

@end

@interface LEDEditTableHeader : UITableViewHeaderFooterView

@property id<LEDEditHeaderDelegae> delegate;

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIControl *accessoryView;

@end


