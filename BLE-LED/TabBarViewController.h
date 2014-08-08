//
//  TabBarViewController.h
//  BLE-LED
//
//  Created by xlliu on 14-8-7.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEDItem.h"

@interface TabBarViewController : UITabBarController

@property (nonatomic,strong) NSMutableArray *allLEDs;
@property (nonatomic,strong) NSMutableArray *allScenes;

@end
