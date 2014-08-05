//
//  CellBackGroud.m
//  CollectionView-Study
//
//  Created by xlliu on 14-7-30.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "CellBackGroud.h"

@implementation CellBackGroud

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef aRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(aRef);
    UIBezierPath *bzierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0f];
    [bzierPath setLineWidth:5.0f];
    [[UIColor blackColor] setStroke];
    
    UIColor *fillColor = [UIColor colorWithRed:0.529 green:0.808 blue:0.922 alpha:1];
    [fillColor setFill];
    
    [bzierPath stroke];
    [bzierPath fill];
    CGContextRestoreGState(aRef);
}
 

@end
