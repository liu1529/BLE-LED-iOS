//
//  GroupItem.m
//  BLE-LED
//
//  Created by xlliu on 14-9-16.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "GroupItem.h"

@interface GroupItem()

@property (strong, nonatomic) NSMutableSet *LEDSet;

@end

@implementation GroupItem

- (NSArray *)keysForEncoding;
{
    return @[@"name", @"image", @"LEDSet"];
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

- (instancetype)initWithName:(NSString *)name Image:(UIImage *)image
{
    if (self = [super init])
    {
        self.name = name;
        self.image = image;
        _LEDSet = [[NSMutableSet alloc] init];
    }
    return self;
}

+ (instancetype)groupWithName:(NSString *)name Image:(UIImage *)image
{
    return [[self.class alloc] initWithName:name Image:image];
}

- (NSSet *)LEDs
{
    return _LEDSet;
}

- (void) addLED:(LEDItem *)aLED
{
    [_LEDSet addObject:aLED];
}
- (void) removeLED:(LEDItem *)aLED
{
    [_LEDSet removeObject:aLED];
}

@end
