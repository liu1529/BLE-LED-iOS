//
//  GrpEditViewController.h
//  BLE-LED
//
//  Created by xlliu on 14-9-16.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

typedef void (^GrpEditCompletionBlock)(BOOL success);

@interface GrpEditViewController : UIViewController

@property (strong, nonatomic) GroupItem *editGrp;
@property (nonatomic) BOOL isAdd;
@property (copy, nonatomic) GrpEditCompletionBlock completionBlock;

@end
