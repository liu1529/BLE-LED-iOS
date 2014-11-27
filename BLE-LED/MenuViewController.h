//
//  MenuViewController.h
//  BLE-LED
//
//  Created by lxl on 14-11-25.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSDynamicsDrawerViewController.h"

typedef NS_ENUM(NSUInteger, PaneViewControllerType) {
    PaneViewControllerTypeLED,
    PaneViewControllerTypeGroup,
    PaneViewControllerTypeScene,
    PaneViewControllerTypeGreeble,
    PaneViewControllerTypeCount
};

@interface MenuViewController : UITableViewController

@property (nonatomic, assign) PaneViewControllerType paneViewControllerType;
@property (nonatomic, weak) MSDynamicsDrawerViewController *dynamicsDrawerViewController;

- (void)transitionToViewController:(PaneViewControllerType)paneViewControllerType;

@end
