//
//  LEDItem.h
//  BLE-LED
//
//  Created by xlliu on 14-7-31.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreBluetooth;

@interface LEDItem : NSObject <CBPeripheralDelegate>

@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *name;
@property (nonatomic) UIImage *selectedImage;
@property (nonatomic, getter = getLight) unsigned char currentLight;
@property (nonatomic) unsigned char currentTemp;
@property (nonatomic) CBPeripheral *bluePeripheral;

@end

#define LED_LIGHT_MAX           255
#define LED_TEMP_MAX            255

#define LED_SERVICE_UUID        [CBUUID UUIDWithString:@"DC00"]
#define LED_SERVICE_UUIDS       @[LED_SERVICE_UUID]

//ONLY READ
#define LED_CHAR_LIGHT_UUID     [CBUUID UUIDWithString:@"EA00"]
#define LED_CHAR_TEMP_UUID      [CBUUID UUIDWithString:@"EA01"]
#define LED_CHAR_ON_OFF_UUID    [CBUUID UUIDWithString:@"EA02"]
#define LED_CHAR_DIM_RATE_UUID  [CBUUID UUIDWithString:@"EA03"]
#define LED_CHAR_SCENE_UUID     [CBUUID UUIDWithString:@"EA04"]
#define LED_CHAR_GROUP_UUID     [CBUUID UUIDWithString:@"EA05"]
#define LED_CHAR_ID_UUID        [CBUUID UUIDWithString:@"EA06"]
#define LED_CHAR_TYPE_UUID      [CBUUID UUIDWithString:@"EA07"]
#define LED_CHAR_STATE_UUID     [CBUUID UUIDWithString:@"EA08"]

//ONLY WRITE
#define LED_CHAR_CTRL_UUID      [CBUUID UUIDWithString:@"EA80"]
#define LED_CHAR_CTRL_CMD_LIGHT         0X00
#define LED_CHAR_CTRL_CMD_TEMP          0X01
#define LED_CHAR_CTRL_CMD_ON_OFF        0X02
#define LED_CHAR_CTRL_CMD_DIM_RATE      0X03
#define LED_CHAR_CTRL_CMD_SCENE_SET     0X04
#define LED_CHAR_CTRL_CMD_SCENE_CALL    0X05
#define LED_CHAR_CTRL_CMD_GROUP_SET     0X06

#define LED_CHAR_UUIDS          @[LED_CHAR_CTRL_UUID, \
                                LED_CHAR_LIGHT_UUID, \
                                LED_CHAR_TEMP_UUID, \
                                LED_CHAR_ON_OFF_UUID, \
                                LED_CHAR_DIM_RATE_UUID, \
                                LED_CHAR_SCENE_UUID, \
                                LED_CHAR_GROUP_UUID, \
                                LED_CHAR_ID_UUID, \
                                LED_CHAR_TYPE_UUID, \
                                LED_CHAR_STATE_UUID]
