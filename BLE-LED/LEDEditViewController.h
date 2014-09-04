//
//  LEDEditViewController.h
//  BLE-LED
//
//  Created by xlliu on 14-8-4.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEDViewController.h"

typedef void (^LEDEditCompletionBlock)(BOOL success);

@interface LEDEditViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) BOOL isAdd;
@property (strong, nonatomic) LEDItem *editLED;
@property (copy, nonatomic) LEDEditCompletionBlock completionBlock;

@end
