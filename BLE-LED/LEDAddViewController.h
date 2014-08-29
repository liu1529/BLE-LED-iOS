//
//  LEDAddViewController.h
//  BLE-LED
//
//  Created by xlliu on 14-8-5.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEDItem.h"
#import <AVFoundation/AVFoundation.h>

typedef void (^LEDAddCompletionBlock)(BOOL success);

@interface LEDAddViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>


@property (strong, nonatomic) LEDItem *theAddLED;
@property (copy, nonatomic) LEDAddCompletionBlock completionBlock;

@end
