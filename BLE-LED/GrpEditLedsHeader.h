//
//  GrpEditLedsHeader.h
//  BLE-LED
//
//  Created by lxl on 14-10-15.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrpEditHeaderDelegate.h"

@interface GrpEditLedsHeader : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView* imageView;
@property (nonatomic) NSUInteger section;
@property (nonatomic, strong) id<GrpEditHeaderDelegate> delegate;

@end
