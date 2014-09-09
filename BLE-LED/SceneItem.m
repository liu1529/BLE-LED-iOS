//
//  SceneItem.m
//  BLE-LED
//
//  Created by xlliu on 14-8-7.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "SceneItem.h"
@import AudioToolbox;

@interface SceneItem()

@property (strong, nonatomic) NSMutableArray *LEDs;
@property (strong, nonatomic) NSMutableArray *lights;
@property (strong, nonatomic) NSMutableArray *temps;

@end

@implementation SceneItem

- (NSArray *)keysForEncoding;
{
    return @[@"name", @"image", @"LEDs", @"lights", @"temps"];
}

+ (SceneItem *)SceneWithName:(NSString *)name Image:(UIImage *)image
{
    return [[SceneItem alloc] initWithName:name Image:image];
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


- (SceneItem *)initWithName:(NSString *)name Image:(UIImage *)image
{
    if (self = [super init])
    {
        self.name = name;
        self.image = image;
        self.LEDs = [[NSMutableArray alloc] init];
        self.lights = [[NSMutableArray alloc] init];
        self.temps = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addLED:(LEDItem *)aLED
{
    [self.LEDs addObject:aLED];
    [self.lights addObject:@(aLED.currentLight)];
    [self.temps addObject:@(aLED.currentTemp)];
   
}
- (void) removeLED:(LEDItem *)aLED
{
    NSUInteger index = [self.LEDs indexOfObject:aLED];
    if (index != NSNotFound) {
        [self.LEDs removeObjectAtIndex:index];
        [self.lights removeObjectAtIndex:index];
        [self.temps removeObjectAtIndex:index];
        
    }
}

- (void) removeLEDAtIndexe:(NSUInteger )index
{
    [self.LEDs removeObjectAtIndex:index];
    [self.lights removeObjectAtIndex:index];
    [self.temps removeObjectAtIndex:index];
}

- (void) replaceLEDAtIndex:(NSUInteger )index withLED:(LEDItem *)aLED
{
    self.LEDs[index] = aLED;
    self.lights[index] = @(aLED.currentLight);
    self.temps[index] = @(aLED.currentTemp);
    
    
}

- (void) replaceLED:(LEDItem *)old withLED:(LEDItem *)now
{
     NSUInteger index = [self.LEDs indexOfObject:old];
    if (index != NSNotFound) {
        self.LEDs[index] = now;
        self.lights[index] = @(now.currentLight);
        self.temps[index] = @(now.currentTemp);
    }
}

- (void) call
{
   
    for (int i = 0; i < _LEDs.count; i++) {
        [_LEDs[i] setCurrentLight:[_lights[i] unsignedCharValue]];
        [_LEDs[i] setCurrentTemp:[_temps[i] unsignedCharValue]];
    }
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
