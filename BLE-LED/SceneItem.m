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

@end

@implementation SceneItem

- (NSArray *)keysForEncoding;
{
    return @[@"name", @"image", @"LEDs"];
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
    }
    return self;
}

- (void) addLED:(LEDItem *)aLED
{
    [self.LEDs addObject:[aLED copy]];
   
}
- (void) removeLED:(LEDItem *)aLED
{
    if ([self.LEDs containsObject:aLED]) {
        [self.LEDs removeObject:aLED];
    }
}

- (void) replaceLEDAtIndex:(NSUInteger )index withLED:(LEDItem *)aLED
{
    self.LEDs[index] = [aLED copy];
    
}

- (void) call
{
    for (LEDItem *aLED in self.LEDs) {
        aLED.currentTemp = aLED.currentTemp;
        aLED.currentLight = aLED.currentLight;
    }
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
