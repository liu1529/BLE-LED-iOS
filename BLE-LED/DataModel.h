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
#import "GroupItem.h"

@import AudioToolbox;

@interface DataModel : NSObject

@property (strong, nonatomic, readonly) NSArray *LEDs;
@property (strong, nonatomic, readonly) NSArray *groups;
@property (strong, nonatomic, readonly) NSArray *scenes;
@property (strong, nonatomic, readonly) NSDictionary *imageDic;

+ (DataModel *) sharedDataModel;

#pragma mark - LEDs;
- (void) addLEDToList:(LEDItem *)aLED;
- (void) removeLEDFromList:(LEDItem *)aLED;
- (LEDItem *) LEDForIdentifier:(NSUUID *)indentifier;

#pragma mark - Groups;
- (void) addGroup:(GroupItem *)grp;
- (void) addLED:(LEDItem *) aLED ToGroup:(GroupItem *)group;
- (void) removeLED:(LEDItem *)aLED FromGroup:(GroupItem *)grp;

#pragma mark - Scenes;
- (void) addScene:(SceneItem *)scene;
- (void) addLEDToScene:(LEDItem *)theLED ToScene:(SceneItem *)scene;
- (void) removeSceneFromList:(SceneItem *)scene;
- (void) clearScenes;



- (void) saveData;

@end
