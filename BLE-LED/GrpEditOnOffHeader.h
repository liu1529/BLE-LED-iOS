//
//  GrpEditOnOffHeader.h
//  BLE-LED
//
//  Created by lxl on 14-10-15.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrpEditHeaderDelegate.h"

@interface GrpEditOnOffHeader : UICollectionReusableView

@property (nonatomic) NSUInteger section;
@property (weak, nonatomic) IBOutlet UISwitch *sw;
@property (nonatomic, strong) id<GrpEditHeaderDelegate> delegate;

@end
