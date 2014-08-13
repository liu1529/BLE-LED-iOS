//
//  SceneAddViewController.h
//  BLE-LED
//
//  Created by xlliu on 14-8-7.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneItem.h"
#import "LEDItem.h"

@interface SceneAddViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) NSIndexPath *editIndexPath;

- (IBAction)unWindToHere:(id)sender;

@end
