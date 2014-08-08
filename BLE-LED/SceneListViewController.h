//
//  SceneListViewController.h
//  BLE-LED
//
//  Created by xlliu on 14-8-7.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneItem.h"

@interface SceneListViewController : UICollectionViewController <UIActionSheetDelegate>

@property (strong,nonatomic) SceneItem* addScene;
@property (weak,nonatomic) SceneItem* editScene;

- (IBAction)unWindToHere: (id)sender;

@end
