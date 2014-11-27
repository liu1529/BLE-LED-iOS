//
//  SceneAddViewController.m
//  BLE-LED
//
//  Created by xlliu on 14-8-7.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "SceneEditViewController.h"
#import "SceneListViewController.h"
#import "ChooseLEDViewController.h"
#import "UIImage+Filter.h"
#import "DataModel.h"


@interface SceneEditViewController () <UIActionSheetDelegate>
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:_isAdd animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.editScene.LEDs.count + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SceneTabbleCell" forIndexPath:indexPath];
    
    if (indexPath.row >= self.editScene.LEDs.count) {
        cell.imageView.image = [UIImage imageNamed:@"add_icon.png"];
        cell.textLabel.text = @"Add LED";
        cell.detailTextLabel.text = @"Add a LED to the scene";
        return cell;
    }
    
    LEDItem *aLED = self.editScene.LEDs[indexPath.row];
   
    
    unsigned char light = [self.editScene.lights[indexPath.row] unsignedCharValue];
    unsigned char temp = [self.editScene.temps[indexPath.row] unsignedCharValue];
    
    cell.imageView.image = aLED.bluePeripheral ? aLED.image : [aLED.image withFilterName: @"CIPhotoEffectMono"];
    cell.textLabel.text = aLED.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:
                                 @"L:%d%% T:%d%%",
                                 (int)((float)light / LED_LIGHT_MAX * 100),
                                 (int)((float)temp / LED_TEMP_MAX * 100)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toSceneLEDChoose" sender:indexPath];
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
        NSIndexPath *index = sender;
       
        
        if (index.row < self.editScene.LEDs.count)
        {
            //edit led
            chooseVC.editLEDIndex = sender;
            chooseVC.isAdd = NO;
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
            //add led
            chooseVC.isAdd = YES;
           
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

- (IBAction) transhScene:(id) sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Delete Scene"
                                  otherButtonTitles:nil];
    [actionSheet showFromBarButtonItem:sender animated:YES];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[DataModel sharedDataModel] removeSceneFromList:_editScene];
        if (self.completionBlock) {
            self.completionBlock(YES);
        }
    }
}




@end
