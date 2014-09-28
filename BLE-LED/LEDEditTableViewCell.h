//
//  LEDEditTableViewCell.h
//  BLE-LED
//
//  Created by xlliu on 14-9-24.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEDEditTableViewCell : UITableViewCell

@property (weak, nonatomic)  IBOutlet UILabel *label;
@property (weak, nonatomic)  IBOutlet UISlider *slider;

@end
