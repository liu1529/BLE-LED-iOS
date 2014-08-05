//
//  LEDCollectionView.h
//  BLE-LED
//
//  Created by xlliu on 14-8-4.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEDCollectionView : UICollectionView <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) NSMutableArray *LEDs;
@end
