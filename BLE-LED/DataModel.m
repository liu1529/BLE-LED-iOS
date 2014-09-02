//
//  DataModel.m
//  BLE-LED
//
//  Created by xlliu on 14-8-28.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "DataModel.h"


@interface DataModel()

@property (strong, nonatomic) NSMutableArray *LEDs;
@property (strong, nonatomic) NSMutableArray *selectLEDs;
@property (strong, nonatomic) NSMutableArray *Scenes;

@end

@implementation DataModel

static DataModel *_sharedDataModel = nil;

+ (DataModel *)sharedDataModel
{
    if (!_sharedDataModel) {
        _sharedDataModel = [[self alloc] init];
    }
    return _sharedDataModel;
}

- (id)init
{
    if (self = [super init])
    {
        self.LEDs = [[NSMutableArray alloc] init];
        self.selectLEDs = [[NSMutableArray alloc] init];
        self.Scenes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addLEDtoSelects:(LEDItem *)aLED
{
    aLED.state = LEDStateSelected;
    [self.selectLEDs addObject:aLED];
}

- (void)addLEDToList:(LEDItem *)aLED
{
    [self.LEDs addObject:aLED];
}

- (void) addScene:(SceneItem *)scene
{
    [self.Scenes addObject:scene];
}

- (void)addLEDToScene:(LEDItem *)theLED ToScene:(SceneItem *)scene
{
    if ([self.Scenes containsObject:scene])
    {
        [scene.LEDs addObject:theLED];
    }
}

- (void) removeLEDFromList:(LEDItem *)aLED
{
    [self.LEDs removeObject:aLED];
}
- (void) removeLEDFromSelects:(LEDItem *)aLED
{
    aLED.state = LEDStateDisSelected;
    [self.selectLEDs removeObject:aLED];
}

- (void) removeSceneFromList:(SceneItem *)scene
{
    [self.Scenes removeObject:scene];
}

- (void) clearLEDs
{
    [self.LEDs removeAllObjects];
    [self.selectLEDs removeAllObjects];
}
- (void) clearSelectsLEDs
{
    [self.selectLEDs removeAllObjects];
}
- (void) clearScenes
{
    [self.Scenes removeAllObjects];
}

@end
