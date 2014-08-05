//
//  LEDCollectionCell.h
//  BLE-LED
//
//  Created by xlliu on 14-7-31.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEDItem.h"

@interface LEDCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;


@end
