//
//  DataModel.h
//  BLE-LED
//
//  Created by xlliu on 14-8-28.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEDItem.h"
#import "SceneItem.h"

@import AudioToolbox;

@interface DataModel : NSObject

@property (strong, nonatomic, readonly) NSMutableArray *LEDs;
@property (strong, nonatomic, readonly) NSMutableArray *selectLEDs;
@property (strong, nonatomic, readonly) NSMutableArray *Scenes;

+ (DataModel *) sharedDataModel;

- (void) addLEDToList:(LEDItem *)aLED;
- (void) addLEDtoSelects:(LEDItem *) aLED;
- (void) addScene:(SceneItem *)scene;
- (void) addLEDToScene:(LEDItem *)theLED ToScene:(SceneItem *)scene;

- (void) removeLEDFromList:(LEDItem *)aLED;
- (void) removeLEDFromSelects:(LEDItem *)aLED;
- (void) removeSceneFromList:(SceneItem *)scene;

- (void) clearLEDs;
- (void) clearSelectsLEDs;
- (void) clearScenes;

@end
