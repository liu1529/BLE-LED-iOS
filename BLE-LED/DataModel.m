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

@property (strong, nonatomic) NSMutableDictionary *dataDic;

@end


@implementation DataModel

static DataModel *_sharedDataModel = nil;

+ (DataModel *)sharedDataModel
{
    static dispatch_once_t  onceToken;
    static DataModel * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[DataModel alloc] init];
    });
    
    return sSharedInstance;
}

// returns the URL to the application's Documents directory
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSDocumentDirectory
             inDomains:NSUserDomainMask] lastObject];
}

- (id)init
{
    if (self = [super init])
    {
    
       
        NSURL *dataFileURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SavedData"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[dataFileURL path]])
        {
            // saved file exists, load it's content from that path
            // note: unarchiveObjectWithFile returns an immutable array, we need to make it mutable
            //
            _dataDic = [[NSKeyedUnarchiver unarchiveObjectWithFile:[dataFileURL path]] mutableCopy];
            _LEDs = _dataDic[@"SavedLEDs"];
            _selectLEDs =_dataDic[@"SavedSelectLEDs"];
            _Scenes = _dataDic[@"SavedScenes"];
            
        }
        else
        {
            _dataDic = [[NSMutableDictionary alloc] init];
            _LEDs = [[NSMutableArray alloc] init];
            _selectLEDs = [[NSMutableArray alloc] init];
            _Scenes = [[NSMutableArray alloc] init];
            
            
            _dataDic[@"SavedLEDs"] = _LEDs;
            _dataDic[@"SavedSelectLEDs"] = _selectLEDs;
            _dataDic[@"SavedScenes"] = _Scenes;
        }
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


- (void) saveData
{
    NSURL *dataFileURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SavedData"];
    [NSKeyedArchiver archiveRootObject:self.dataDic toFile:[dataFileURL path]];
}

@end
