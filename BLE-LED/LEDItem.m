//
//  LEDItem.m
//  BLE-LED
//
//  Created by xlliu on 14-7-31.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "LEDItem.h"

@interface LEDItem () <NSCopying>

@end

@implementation LEDItem


- (id)copyWithZone:(NSZone *)zone
{
    LEDItem *LED = [[self class] allocWithZone:zone];
    LED.image = self.image;
    LED.name = self.name;
    LED.currentLight = self.currentLight;
    LED.currentTemp = self.currentTemp;
    LED.bluePeripheral = self.bluePeripheral;
    LED.state = self.state;
    
    return LED;
}


+ (id)LEDWithName:(NSString *)name Image:(UIImage *)image
{
    return [[LEDItem alloc] initWithName:name Image:image];
}

- (id)initWithName:(NSString *)name Image:(UIImage *)image
{
    if (self = [super init]) {
        self.name = name;
        self.image = image;
        self.state = LEDStateDisSelected;
    }
    return self;
}


- (void)setCurrentLight:(unsigned char)currentLight
{
    CBCharacteristic *charac = nil;
    
    if (charac == nil)
    {
        for (CBCharacteristic *c in self.characteristics) {
            if ([c.UUID isEqual:LED_CHAR_CTRL_UUID]) {
                charac = c;
            }
        }
    }
    
    if (charac &&
        charac.properties & CBCharacteristicPropertyWrite) {
        NSMutableData *data = [NSMutableData new];
        unsigned char Cmd = LED_CHAR_CTRL_CMD_LIGHT;
        [data appendBytes:&Cmd length:1];
        [data appendBytes:&currentLight length:1];
       
        
        [self.bluePeripheral writeValue:data forCharacteristic:charac type:CBCharacteristicWriteWithResponse];
        
         printf("p:%s c:%s w 0x%s\n",[[self.bluePeripheral.identifier UUIDString] UTF8String],[charac.UUID.data.description UTF8String], [data.description UTF8String]);
    }
    else
    {
         printf("p:%s c:%s is nil\n",[[self.bluePeripheral.identifier UUIDString] UTF8String],[charac.UUID.data.description UTF8String]);
    }
    _currentLight = currentLight;

}



- (void)setCurrentTemp:(unsigned char)currentTemp
{
    CBCharacteristic *charac = nil;
    
    if (charac == nil)
    {
        for (CBCharacteristic *c in self.characteristics) {
            if ([c.UUID isEqual:LED_CHAR_CTRL_UUID]) {
                charac = c;
            }
        }
    }
    
    if (charac &&
        charac.properties & CBCharacteristicPropertyWrite) {
        NSMutableData *data = [NSMutableData new];
        unsigned char Cmd = LED_CHAR_CTRL_CMD_TEMP;
        [data appendBytes:&Cmd length:1];
        [data appendBytes:&currentTemp length:1];
        
        
        [self.bluePeripheral writeValue:data forCharacteristic:charac type:CBCharacteristicWriteWithResponse];
        
        printf("p:%s c:%s w 0x%s\n",[[self.bluePeripheral.identifier UUIDString] UTF8String],[charac.UUID.data.description UTF8String], [data.description UTF8String]);
    }
    else
    {
        printf("p:%s c:%s is nil\n",[[self.bluePeripheral.identifier UUIDString] UTF8String],[charac.UUID.data.description UTF8String]);
    }
    _currentTemp = currentTemp;
}




@end




