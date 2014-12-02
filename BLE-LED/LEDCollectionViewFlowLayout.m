//
//  LEDCollectionViewFlowLayout.m
//  BLE-LED
//
//  Created by lxl on 14/12/1.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "LEDCollectionViewFlowLayout.h"

@implementation LEDCollectionViewFlowLayout



- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attrs = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        if (attr.representedElementCategory == UICollectionElementCategoryCell) {
            
        }
    }
    
    return attrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *att = [super layoutAttributesForItemAtIndexPath:indexPath];
    return att;
}

@end
