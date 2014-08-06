//
//  LEDAddViewController.m
//  BLE-LED
//
//  Created by xlliu on 14-8-5.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "LEDAddViewController.h"
#import "LEDViewController.h"

@interface LEDAddViewController ()

@property LEDViewController *listViewController;

- (IBAction)backToLEDList:(id)sender;

@end

@implementation LEDAddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITabBarController *tabBarController = (UITabBarController *)self.presentingViewController;
    UINavigationController *naviController = (UINavigationController *)tabBarController.selectedViewController;
    self.listViewController = (LEDViewController *)naviController.topViewController;
    
    if (self.listViewController.addLED == nil) {
         self.listViewController.addLED = [[LEDItem alloc] init];
    }
    self.addLED = self.listViewController.addLED;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)unWindToAdd:(id)sender
{
    if (self.addLED.image) {
        [self.listViewController unWindToList:sender];
        [self dismissViewControllerAnimated:YES completion:^(void)
         {
             
         }];
    }
}

- (IBAction)backToLEDList:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}
@end
