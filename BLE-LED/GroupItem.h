//
//  GroupItem.h
//  BLE-LED
//
//  Created by xlliu on 14-9-16.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEDItem.h"

@interface GroupItem : NSObject

@property (copy, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic, readonly) NSSet *LEDs;


+ (instancetype)groupWithName:(NSString *)name Image:(UIImage *)image;
- (void) addLED:(LEDItem *)aLED;
- (void) removeLED:(LEDItem *)aLED;

@end
