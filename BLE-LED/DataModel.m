//
//  DataModel.m
//  BLE-LED
//
//  Created by xlliu on 14-8-28.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "DataModel.h"


@interface DataModel()

@property (strong, nonatomic) NSMutableArray *LEDArray;
@property (strong, nonatomic) NSMutableArray *groupArray;
@property (strong, nonatomic) NSMutableArray *sceneArray;
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
            _LEDArray = _stroeDataDic[@"SavedLEDs"];
            _groupArray = _stroeDataDic[@"SavedGroups"];
            _sceneArray = _stroeDataDic[@"SavedScenes"];
            
        }
        else
        {
            _stroeDataDic = [[NSMutableDictionary alloc] init];
            _LEDArray = [[NSMutableArray alloc] init];
            _groupArray = [[NSMutableArray alloc] init];
            _sceneArray = [[NSMutableArray alloc] init];
            
            
            _stroeDataDic[@"SavedLEDs"] = _LEDArray;
            _stroeDataDic[@"SavedGroups"] = _groupArray;
            _stroeDataDic[@"SavedScenes"] = _sceneArray;
        }
    }
    return self;
}

#pragma mark - LEDs

- (NSArray *)LEDs
{
    return _LEDArray;
}

- (void)addLEDToList:(LEDItem *)aLED
{
    [_LEDArray addObject:aLED];
    
}

- (void) removeLEDFromList:(LEDItem *)aLED
{
    for (SceneItem *scene in _sceneArray) {
        [scene removeLED:aLED];
    }
    for (GroupItem *group in _groupArray) {
        [group removeLED:aLED];
    }
    [_LEDArray removeObject:aLED];
    
}

- (LEDItem *) LEDForIdentifier:(NSUUID *)indentifier
{
    for (LEDItem *aLED in _LEDArray) {
        if ([aLED.identifier isEqual:indentifier]) {
            return aLED;
        }
    }
    return nil;
}

#pragma mark - Groups

- (NSArray *)groups
{
    return _groupArray;
}

- (void) addGroup:(GroupItem *)grp
{
    [_groupArray addObject:grp];
}

- (void) addLED:(LEDItem *) aLED ToGroup:(GroupItem *)group
{
    if ([_groupArray containsObject:group]) {
        [group addLED:aLED];
    }
}

- (void) removeLED:(LEDItem *)aLED FromGroup:(GroupItem *)grp
{
    if ([grp.LEDs containsObject:aLED]) {
        [grp removeLED:aLED];
    }
}

#pragma mark - Scenes

- (NSArray *)scenes
{
    return _sceneArray;
}

- (void) addScene:(SceneItem *)scene
{
    [_sceneArray addObject:scene];
   
}

- (void)addLEDToScene:(LEDItem *)theLED ToScene:(SceneItem *)scene
{
    if ([_sceneArray containsObject:scene])
    {
        [scene.LEDs addObject:theLED];
        
    }
}


- (void) removeSceneFromList:(SceneItem *)scene
{
    [_sceneArray removeObject:scene];
    
}

- (void) clearScenes
{
    [_sceneArray removeAllObjects];
    
}


- (void) saveData
{
    NSURL *dataFileURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SavedData"];
    [NSKeyedArchiver archiveRootObject:_stroeDataDic toFile:[dataFileURL path]];
}

@end
