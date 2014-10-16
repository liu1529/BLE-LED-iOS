//
//  GrpEditCellDelegate.h
//  BLE-LED
//
//  Created by lxl on 14-10-15.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GrpEditCellDelegate <NSObject>

- (void) grpEditCell:(UICollectionViewCell *)cell valueChangeInView:(UIView *)view;

@end
