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
@property (strong, nonatomic) NSDictionary *imageDic;

@property (strong, nonatomic) NSMutableDictionary *stroeDataDic;

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
    
        _imageDic = @{
                      @"LEDImages":
                        @[[UIImage imageNamed:@"LED0.png"],
                          [UIImage imageNamed:@"LED1.png"],
                          [UIImage imageNamed:@"LED2.png"]
                          ],
                      @"SceneImages":
                          @[[UIImage imageNamed:@"scene0.png"],
                            [UIImage imageNamed:@"scene1.png"],
                            [UIImage imageNamed:@"scene2.png"],
                            [UIImage imageNamed:@"scene3.png"],
                            [UIImage imageNamed:@"scene4.png"],
                            [UIImage imageNamed:@"scene5.png"],
                            [UIImage imageNamed:@"scene6.png"],
                            [UIImage imageNamed:@"scene7.png"]
                            ]
                      
                      };
        
       
        NSURL *dataFileURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SavedData"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[dataFileURL path]])
        {
            // saved file exists, load it's content from that path
            // note: unarchiveObjectWithFile returns an immutable array, we need to make it mutable
            //
            _stroeDataDic = [[NSKeyedUnarchiver unarchiveObjectWithFile:[dataFileURL path]] mutableCopy];
            _LEDs = _stroeDataDic[@"SavedLEDs"];
            _selectLEDs =_stroeDataDic[@"SavedSelectLEDs"];
            _Scenes = _stroeDataDic[@"SavedScenes"];
            
        }
        else
        {
            _stroeDataDic = [[NSMutableDictionary alloc] init];
            _LEDs = [[NSMutableArray alloc] init];
            _selectLEDs = [[NSMutableArray alloc] init];
            _Scenes = [[NSMutableArray alloc] init];
            
            
            _stroeDataDic[@"SavedLEDs"] = _LEDs;
            _stroeDataDic[@"SavedSelectLEDs"] = _selectLEDs;
            _stroeDataDic[@"SavedScenes"] = _Scenes;
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
    [NSKeyedArchiver archiveRootObject:_stroeDataDic toFile:[dataFileURL path]];
}

@end
