//
//  GrpEditOnOffHeader.m
//  BLE-LED
//
//  Created by lxl on 14-10-15.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "GrpEditOnOffHeader.h"

@interface GrpEditOnOffHeader ()



@end

@implementation GrpEditOnOffHeader

- (void)awakeFromNib {
    // Initialization code
    
    [self.sw addTarget:self action:@selector(OnOffChange) forControlEvents:UIControlEventValueChanged];
    
}

- (void) OnOffChange
{
    if (![self.delegate respondsToSelector:@selector(grpEditHeader:inSection:valueChangeInView:)])
        return;
    [self.delegate grpEditHeader:self inSection:self.section valueChangeInView:self.sw];
}

@end
