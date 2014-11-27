//
//  MenuHeader.m
//  BLE-LED
//
//  Created by lxl on 14-11-25.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "MenuHeader.h"

@implementation MenuHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - NSObject

+ (void)load
{
    id labelAppearance = [UILabel appearanceWhenContainedIn:[self class], nil];
    [labelAppearance setFont:[UIFont systemFontOfSize:13.0]];
    [labelAppearance setTextColor:[UIColor whiteColor]];
}

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *backgoundView = [UIView new];
        backgoundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.backgroundView = backgoundView;
    }
    return self;
}

@end
