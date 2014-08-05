//
//  LEDCollectionView.m
//  BLE-LED
//
//  Created by xlliu on 14-8-4.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "LEDCollectionView.h"
#import "LEDItem.h"
#import "LEDCollectionCell.h"

@implementation LEDCollectionView

NSString *kCellID = @"CellLED";                          // UICollectionViewCell storyboard id

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.LEDs = [[NSMutableArray alloc] init];
        [self loadInit];
    }
    return self;
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.LEDs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LEDCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    LEDItem *aLED = self.LEDs[indexPath.row];
    cell.imageView.image = aLED.image;
    cell.nameLabel.text = aLED.name;
    
    
    return cell;
}

- (void) loadInit
{
    LEDItem *aLED = [[LEDItem alloc] init];
    aLED.image = [UIImage imageNamed:@"0.JPG"];
    aLED.name = @"LED";
    
    [self.LEDs addObject:aLED];
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
