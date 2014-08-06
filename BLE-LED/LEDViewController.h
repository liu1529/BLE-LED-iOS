//
//  LEDViewController.h
//  BLE-LED
//
//  Created by xlliu on 14-8-4.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEDItem.h"

@interface LEDViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) LEDItem *editLED;
@property (strong,nonatomic) LEDItem *addLED;


- (IBAction)unWindToList:(id)sender;


@end
