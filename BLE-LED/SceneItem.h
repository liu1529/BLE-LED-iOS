//
//  SceneItem.h
//  BLE-LED
//
//  Created by xlliu on 14-8-7.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEDItem.h"

@interface SceneItem : NSObject

@property (copy, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic, readonly) NSMutableArray *LEDs;
@property (strong, nonatomic, readonly) NSMutableArray *lights;
@property (strong, nonatomic, readonly) NSMutableArray *temps;

+ (SceneItem *)SceneWithName:(NSString *)name Image:(UIImage *)image;
- (void) addLED:(LEDItem *)aLED;
- (void) removeLED:(LEDItem *)aLED;
- (void) replaceLEDAtIndex:(NSUInteger )index withLED:(LEDItem *)aLED;
- (void) replaceLED:(LEDItem *)old withLED:(LEDItem *)now;
- (void) call;

@end
