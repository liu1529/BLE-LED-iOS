//
//  GrpEditLedsHeader.m
//  BLE-LED
//
//  Created by lxl on 14-10-15.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "GrpEditLedsHeader.h"

@interface GrpEditLedsHeader ()



@end

@implementation GrpEditLedsHeader

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    gr.numberOfTapsRequired = 1;
    [self addGestureRecognizer:gr];
}

- (void)tap
{
    if (![self.delegate respondsToSelector:@selector(grpEditHeader:inSection:valueChangeInView:)])
        return;
    [self.delegate grpEditHeader:self inSection:self.section valueChangeInView:self];
}

@end
