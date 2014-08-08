//
//  SceneAddViewController.m
//  BLE-LED
//
//  Created by xlliu on 14-8-7.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "SceneAddViewController.h"
#import "TabBarViewController.h"
#import "SceneListViewController.h"


@interface SceneAddViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) NSMutableArray *scenes;
@property (weak, nonatomic) SceneListViewController *listVC;


- (IBAction)doneActione:(id)sender;


@end

@implementation SceneAddViewController

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
    self.tableView.dataSource = self;
    
    self.scenes = ((TabBarViewController *)self.tabBarController).allScenes;
    self.listVC = (SceneListViewController *)(self.navigationController.viewControllers[0]);
    
    self.imageView.image = self.listVC.addScene.image;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listVC.addScene.LEDs.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SceneTabbleCell" forIndexPath:indexPath];
    LEDItem *aLED = self.listVC.addScene.LEDs[indexPath.row];
    
    cell.imageView.image = aLED.image;
    cell.textLabel.text = aLED.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"L:%d%% T:%d%%",aLED.currentLight,aLED.currentTemp];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneActione:(id)sender {
    [self.navigationController popToViewController:self.listVC animated:YES];
    [self.listVC unWindToHere:sender];
    
}

- (IBAction)unWindToHere:(id)sender
{
    [self.tableView reloadData];
}




@end