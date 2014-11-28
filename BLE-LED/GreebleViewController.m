//
//  GreebleViewController.m
//  BLE-LED
//
//  Created by lxl on 14/11/27.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "GreebleViewController.h"

@interface GreebleViewController ()

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

NSString * const GreebleURL = @"http://www.scjz-led.com/en/About.aspx";

@implementation GreebleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.webView.backgroundColor = [UIColor blackColor];
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:GreebleURL]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
