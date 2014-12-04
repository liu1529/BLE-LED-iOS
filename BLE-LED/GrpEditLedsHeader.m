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
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    UIColor *c = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    UIView *topSeparateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 1)];
    topSeparateView.backgroundColor = c;
    [self addSubview:topSeparateView];
    
    UIView *bottomSeparateView = [[UIView alloc] initWithFrame:CGRectMake(0, h - 1, w, 1)];
    bottomSeparateView.backgroundColor = c;
    [self addSubview:bottomSeparateView];
    
}

- (void)tap
{
    if (![self.delegate respondsToSelector:@selector(grpEditHeader:inSection:valueChangeInView:)])
        return;
    [self.delegate grpEditHeader:self inSection:self.section valueChangeInView:self];
}

@end
