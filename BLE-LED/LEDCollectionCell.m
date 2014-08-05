//
//  LEDCollectionCell.m
//  BLE-LED
//
//  Created by xlliu on 14-7-31.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "LEDCollectionCell.h"
#import "CellBackGroud.h"

@implementation LEDCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CellBackGroud* cellBackGround = [[CellBackGroud alloc] initWithFrame:CGRectZero];
        self.selectedBackgroundView = cellBackGround;
    }
    return self;
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
