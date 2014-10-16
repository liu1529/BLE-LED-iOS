//
//  GrpEditOnOffCell.h
//  BLE-LED
//
//  Created by lxl on 14-10-15.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrpEditCellDelegate.h"

@interface GrpEditOnOffCell : UICollectionViewCell

@property (strong, nonatomic)  UILabel *label;
@property (strong, nonatomic)  UISlider *slider;

@property (strong, nonatomic) id<GrpEditCellDelegate> delegate;

@end
