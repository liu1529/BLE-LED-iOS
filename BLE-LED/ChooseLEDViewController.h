//
//  ChooseLEDViewController.h
//  BLE-LED
//
//  Created by xlliu on 14-8-7.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEDItem.h"
#import "SceneItem.h"

typedef void (^ChooseLEDCompletionBlock)(BOOL success);

@interface ChooseLEDViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) LEDItem *editLED;
@property (weak, nonatomic) SceneItem *editScene;
@property (copy, nonatomic) ChooseLEDCompletionBlock completionBlock;

@end
