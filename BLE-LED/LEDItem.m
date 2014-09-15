//
//  LEDItem.m
//  BLE-LED
//
//  Created by xlliu on 14-7-31.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "LEDItem.h"


@interface LEDItem () <NSCopying, NSCoding>

@property (strong, nonatomic) NSString *blueAddrWithColon;
@property (copy, nonatomic) NSString *blueAddr;
@property (strong, nonatomic) NSArray *blueAddrBytes;
@end



@implementation LEDItem

@synthesize QRCodeString = _QRCodeString;

- (NSArray *)keysForEncoding;
{
    return @[@"name", @"image", @"identifier", @"blueAddr",@"blueAddrWithColon"];
}

- (id)copyWithZone:(NSZone *)zone
{
    LEDItem *LED = [[self class] allocWithZone:zone];
    LED.image = self.image;
    LED.name = self.name;
    LED.currentLight = self.currentLight;
    LED.currentTemp = self.currentTemp;
    LED.QRCodeString = _QRCodeString;
    LED.bluePeripheral = self.bluePeripheral;
    LED.characteristics = self.characteristics;
    LED.state = self.state;
    
    return LED;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        for (NSString *key in [self keysForEncoding]) {
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    for (NSString *key in self.keysForEncoding)
    {
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
}

- (BOOL)isEqual:(id)object
{
    return [[self blueAddr] isEqualToString:[object blueAddr]];
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


- (void)setQRCodeString:(NSString *)QRCodeString
{

    NSArray *addrAndName = [QRCodeString componentsSeparatedByString:@","];
    if (2 != addrAndName.count) {
        return ;
    }

    
    NSArray *addrItems = [addrAndName[0] componentsSeparatedByString:@":"];
    if (addrItems.count != 6) {
        return ;
    }
   
    NSMutableString *addr = [[NSMutableString alloc] init];
    for (NSString *addrItem in addrItems) {
        if (addrItem.intValue > 0xff) {
            return;
        }
        [addr appendString:addrItem];
    }
    
    _blueAddrBytes = addrItems;
    _blueAddrWithColon = addrAndName[0];
    _name = addrAndName[1];
    _blueAddr = addr;
    _QRCodeString = QRCodeString;
    
}

- (NSString *)QRCodeString
{
 
    NSMutableString *s = [[NSMutableString alloc] initWithString:_blueAddrWithColon];
    [s appendFormat:@",%@",_name];
    _QRCodeString = s;
    
    return _QRCodeString;
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
        charac.properties & CBCharacteristicPropertyWrite)
    {
        
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




- (void) writeConfirmation:(NSData *)confimation
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
        unsigned char Cmd = LED_CHAR_CTRL_CMD_CONFIRM;
        [data appendBytes:&Cmd length:1];
        [data appendData:confimation];
    
        [self.bluePeripheral writeValue:data forCharacteristic:charac type:CBCharacteristicWriteWithResponse];
        
        printf("p:%s c:%s w 0x%s\n",[[self.bluePeripheral.identifier UUIDString] UTF8String],[charac.UUID.data.description UTF8String], [data.description UTF8String]);
    }
    else
    {
        printf("p:%s c:%s is nil\n",[[self.bluePeripheral.identifier UUIDString] UTF8String],[charac.UUID.data.description UTF8String]);
    }

}


@end




