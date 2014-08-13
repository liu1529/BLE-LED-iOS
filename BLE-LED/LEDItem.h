//
//  LEDItem.h
//  BLE-LED
//
//  Created by xlliu on 14-7-31.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEDItem : NSObject <NSCopying>

@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *name;
@property (nonatomic) UIImage *selectedImage;
@property (nonatomic) unsigned char currentLight;
@property (nonatomic) unsigned char currentTemp;

@end
