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
@property (weak, nonatomic) SceneItem *currentScene;
@property (weak, nonatomic) SceneListViewController *listVC;


- (IBAction)doneActione:(id)sender;
- (IBAction)hideKeyboard:(id)sender;


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
    self.tableView.delegate = self;
    
    self.scenes = ((TabBarViewController *)self.tabBarController).allScenes;
    self.listVC = (SceneListViewController *)(self.navigationController.viewControllers[0]);
    
    self.currentScene = (self.listVC.addScene) ? (self.listVC.addScene) : (self.listVC.editScene);
    self.imageView.image = self.currentScene.image;
    self.nameLabel.text = self.currentScene.name;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentScene.LEDs.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SceneTabbleCell" forIndexPath:indexPath];
    LEDItem *aLED = self.currentScene.LEDs[indexPath.row];
   
    
    unsigned char light = ((NSNumber *)(self.currentScene.lights[indexPath.row])).unsignedCharValue;
    unsigned char temp = ((NSNumber *)(self.currentScene.temps[indexPath.row])).unsignedCharValue;
    
    cell.imageView.image = aLED.image;
    cell.textLabel.text = aLED.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"L:%d%% T:%d%%",(int)((float)light / LED_LIGHT_MAX * 100),(int)((float)temp / LED_TEMP_MAX * 100)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.editIndexPath = indexPath;
    [self performSegueWithIdentifier:@"toSceneLEDChoose" sender:self];
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
    self.currentScene.name = self.nameLabel.text;
    self.currentScene.image = self.imageView.image;
    [self.navigationController popToViewController:self.listVC animated:YES];
    [self.listVC unWindToHere:sender];
    
}

- (IBAction)hideKeyboard:(id)sender {
    [self.nameLabel resignFirstResponder];
}

- (IBAction)unWindToHere:(id)sender
{
    [self.tableView reloadData];
}




@end
