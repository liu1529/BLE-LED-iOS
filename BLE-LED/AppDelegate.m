//
//  AppDelegate.m
//  BLE-LED
//
//  Created by xlliu on 14-7-28.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"


@interface AppDelegate () <MSDynamicsDrawerViewControllerDelegate>

@property (nonatomic, strong) UIImageView *windowBackground;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.dynamicsDrawerViewController = (MSDynamicsDrawerViewController *)self.window.rootViewController;
    self.dynamicsDrawerViewController.delegate = self;
    

    [self.dynamicsDrawerViewController addStylersFromArray:@[[MSDynamicsDrawerScaleStyler styler], [MSDynamicsDrawerFadeStyler styler]] forDirection:MSDynamicsDrawerDirectionLeft];
    
    MenuViewController *menuViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    menuViewController.dynamicsDrawerViewController = self.dynamicsDrawerViewController;
    [self.dynamicsDrawerViewController setDrawerViewController:menuViewController forDirection:MSDynamicsDrawerDirectionLeft];

    [menuViewController transitionToViewController:PaneViewControllerTypeLED];
    
    [self.window addSubview:self.windowBackground];
    [self.window sendSubviewToBack:self.windowBackground];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIImageView *)windowBackground
{
    if (!_windowBackground) {
        _windowBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Window Background"]];
    }
    return _windowBackground;
}

- (NSString *)descriptionForPaneState:(MSDynamicsDrawerPaneState)paneState
{
    switch (paneState) {
        case MSDynamicsDrawerPaneStateOpen:
            return @"MSDynamicsDrawerPaneStateOpen";
        case MSDynamicsDrawerPaneStateClosed:
            return @"MSDynamicsDrawerPaneStateClosed";
        case MSDynamicsDrawerPaneStateOpenWide:
            return @"MSDynamicsDrawerPaneStateOpenWide";
        default:
            return nil;
    }
}

- (NSString *)descriptionForDirection:(MSDynamicsDrawerDirection)direction
{
    switch (direction) {
        case MSDynamicsDrawerDirectionTop:
            return @"MSDynamicsDrawerDirectionTop";
        case MSDynamicsDrawerDirectionLeft:
            return @"MSDynamicsDrawerDirectionLeft";
        case MSDynamicsDrawerDirectionBottom:
            return @"MSDynamicsDrawerDirectionBottom";
        case MSDynamicsDrawerDirectionRight:
            return @"MSDynamicsDrawerDirectionRight";
        default:
            return nil;
    }
}

#pragma mark - MSDynamicsDrawerViewControllerDelegate

- (void)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController mayUpdateToPaneState:(MSDynamicsDrawerPaneState)paneState forDirection:(MSDynamicsDrawerDirection)direction
{
    NSLog(@"Drawer view controller may update to state `%@` for direction `%@`", [self descriptionForPaneState:paneState], [self descriptionForDirection:direction]);
}

- (void)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController didUpdateToPaneState:(MSDynamicsDrawerPaneState)paneState forDirection:(MSDynamicsDrawerDirection)direction
{
    NSLog(@"Drawer view controller did update to state `%@` for direction `%@`", [self descriptionForPaneState:paneState], [self descriptionForDirection:direction]);
}

@end
