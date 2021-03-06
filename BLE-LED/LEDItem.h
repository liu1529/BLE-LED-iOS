//
//  LEDItem.h
//  BLE-LED
//
//  Created by xlliu on 14-7-31.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreBluetooth;

typedef enum {
    LEDStateDisConnected,
    LEDStateConecting,
    LEDStateConnected,
}LEDState;





@interface LEDItem : NSObject

@property (copy, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSUUID *identifier;
@property (copy, nonatomic ,readonly) NSString *blueAddr;
@property (copy, nonatomic) NSString *QRCodeString;
@property (nonatomic) BOOL onOff;
@property (nonatomic) unsigned char currentLight;
@property (nonatomic) unsigned char currentTemp;
@property (strong, nonatomic) CBPeripheral *bluePeripheral;
@property (strong, nonatomic) NSArray *characteristics;
@property LEDState state;       //是否被选中，用于调光

+ (id) LEDWithName:(NSString *)name Image:(UIImage *)image;
- (void) writeConfirmation:(NSData *)confimation;

@end



#define LED_LIGHT_MAX           255
#define LED_LIGHT_MIN           8
#define LED_TEMP_MAX            255
#define LED_TEMP_MIN            0

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
#define LED_CHAR_CTRL_CMD_CONFIRM       0X07


#define LED_CHAR_UUIDS          @[LED_CHAR_CTRL_UUID, \
                                LED_CHAR_LIGHT_UUID, \
                                LED_CHAR_TEMP_UUID, \
                                LED_CHAR_ON_OFF_UUID, \
                                LED_CHAR_DIM_RATE_UUID, \
                                LED_CHAR_SCENE_UUID, \
                                LED_CHAR_ID_UUID, \
                                ]
