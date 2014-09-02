//
//  SceneAddViewController.m
//  BLE-LED
//
//  Created by xlliu on 14-8-7.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "SceneEditViewController.h"
#import "TabBarViewController.h"
#import "SceneListViewController.h"
#import "ChooseLEDViewController.h"


@interface SceneEditViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)doneActione:(id)sender;
- (IBAction)hideKeyboard:(id)sender;


@end

@implementation SceneEditViewController

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
    
    
    self.imageView.image = self.editScene.image;
    self.nameLabel.text = self.editScene.name;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.editScene.LEDs.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SceneTabbleCell" forIndexPath:indexPath];
    LEDItem *aLED = self.editScene.LEDs[indexPath.row];
   
    
    unsigned char light = [self.editScene.lights[indexPath.row] unsignedCharValue];
    unsigned char temp = [self.editScene.temps[indexPath.row] unsignedCharValue];
    
    cell.imageView.image = aLED.image;
    cell.textLabel.text = aLED.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:
                                 @"L:%d%% T:%d%%",
                                 (int)((float)light / LED_LIGHT_MAX * 100),
                                 (int)((float)temp / LED_TEMP_MAX * 100)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"toSceneLEDChoose" sender:self];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toSceneLEDChoose"]) {
        ChooseLEDViewController *chooseVC = segue.destinationViewController;
        chooseVC.editScene = self.editScene;
        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
        if (index)
        {
            //edit led
            chooseVC.editLED = self.editScene.LEDs[index.row];
            chooseVC.completionBlock = ^(BOOL success)
            {
                if (success)
                {
                    [self.tableView reloadData];
                }
                [self.navigationController popViewControllerAnimated:YES];
            };

        }
        else
        {
            chooseVC.completionBlock = ^(BOOL success)
            {
                if (success)
                {
                    [self.tableView reloadData];
                }
                [self.navigationController popViewControllerAnimated:YES];
            };
        }
    }
}


- (IBAction)doneActione:(id)sender {
    self.editScene.name = self.nameLabel.text;
    self.editScene.image = self.imageView.image;
    if (self.completionBlock) {
        self.completionBlock(YES);
    }
}

- (IBAction)hideKeyboard:(id)sender {
    [self.nameLabel resignFirstResponder];
}





@end
