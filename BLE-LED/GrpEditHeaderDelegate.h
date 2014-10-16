//
//  GrpEditHeaderDelegate.h
//  BLE-LED
//
//  Created by lxl on 14-10-15.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GrpEditHeaderDelegate <NSObject>

- (void) grpEditHeader:(UICollectionReusableView *)h inSection:(NSUInteger)section valueChangeInView:(UIView *)view;

@end
