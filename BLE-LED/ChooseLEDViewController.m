//
//  ChooseLEDViewController.m
//  BLE-LED
//
//  Created by xlliu on 14-8-7.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "ChooseLEDViewController.h"
#import "TabBarViewController.h"
#import "SceneAddViewController.h"
#import "SceneListViewController.h"

@interface ChooseLEDViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UILabel *lightLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UISlider *lightSlider;
@property (weak, nonatomic) IBOutlet UISlider *tempSlider;

@property (strong, nonatomic) NSMutableArray *LEDs;
@property (weak, nonatomic) LEDItem *selectedLED;
@property (weak, nonatomic) SceneAddViewController *addVC;
@property (weak, nonatomic) SceneListViewController *listVC;
@property (weak, nonatomic) SceneItem *currentScene;



- (IBAction)lightChange:(id)sender;
- (IBAction)tempChange:(id)sender;
- (IBAction)donePick:(id)sender;
- (IBAction)cancelPick:(id)sender;
@end

@implementation ChooseLEDViewController

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
    
    self.pickView.dataSource = self;
    self.pickView.delegate = self;
    
    self.addVC = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
    self.listVC = (SceneListViewController *)(self.navigationController.viewControllers[0]);
    self.currentScene = (self.listVC.addScene) ? (self.listVC.addScene) : (self.listVC.editScene);
    
    NSMutableArray *LEDs = [[NSMutableArray alloc ]initWithArray:((TabBarViewController *)self.tabBarController).allLEDs];
    for (LEDItem *LED in self.currentScene.LEDs)
    {
        [LEDs removeObject:LED];
    }
    
    if (self.addVC.editIndexPath)
    {
        [LEDs insertObject:self.currentScene.LEDs[self.addVC.editIndexPath.row] atIndex:0];
    }
   
    
    self.LEDs = LEDs;
    
    
    
    if (self.LEDs.count > 0)
    {
        self.selectedLED = self.LEDs[0];
        
        [self.lightSlider setValue:self.selectedLED.currentLight animated:YES];
        [self.tempSlider setValue:self.selectedLED.currentTemp animated:YES];
        
        self.lightLabel.text = [NSString stringWithFormat:@"%d%%",(int)(self.selectedLED.currentLight / self.lightSlider.maximumValue * 100)];
        self.tempLabel.text = [NSString stringWithFormat:@"%d%%",(int)(self.selectedLED.currentTemp / self.tempSlider.maximumValue * 100)];
        
    }
    else
    {
        self.lightSlider.enabled = NO;
        self.tempSlider.enabled = NO;
    }
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  
    return self.LEDs.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return [self.view bounds].size.height / 4;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CGRect bounds = [self.view bounds];
    LEDItem *LED = self.LEDs[row];
    UIView *aView = [[UIView alloc]
                     initWithFrame:CGRectMake(
                                              0,
                                              0,
                                              bounds.size.width,
                                              bounds.size.height / 4)];
    
    
    UILabel *label = [[UILabel alloc]
                      initWithFrame:CGRectMake(
                                               0,
                                               0,
                                               aView.frame.size.width / 2,
                                               aView.frame.size.height)];
    label.text = LED.name;
    [label setTextAlignment:NSTextAlignmentCenter];
    label.adjustsFontSizeToFitWidth = YES;
    
    UIImageView *imageView = [[UIImageView alloc]
                              initWithFrame:CGRectMake(
                                                       aView.frame.size.width / 2,
                                                       0,
                                                       aView.frame.size.width / 2,
                                                       aView.frame.size.height)];
    imageView.image = LED.image;
    
    [aView addSubview:label];
    [aView addSubview:imageView];
    
    
    
    return aView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.LEDs.count > 0) {
        self.selectedLED = self.LEDs[row];
        [self.lightSlider setValue:self.selectedLED.currentLight animated:YES];
        [self.tempSlider setValue:self.selectedLED.currentTemp animated:YES];
        
        self.lightLabel.text = [NSString stringWithFormat:@"%d%%",(int)(self.selectedLED.currentLight / self.lightSlider.maximumValue * 100)];
        self.tempLabel.text = [NSString stringWithFormat:@"%d%%",(int)(self.selectedLED.currentTemp / self.tempSlider.maximumValue * 100)];
    }
    
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

- (IBAction)lightChange:(id)sender {
    UISlider *slider = sender;
     self.selectedLED.currentLight = (unsigned char)(slider.value);
    self.lightLabel.text = [NSString stringWithFormat:@"%d%%",(int)(slider.value / slider.maximumValue * 100)];
   
}

- (IBAction)tempChange:(id)sender {
    UISlider *slider = sender;
    self.selectedLED.currentTemp = slider.value;
    self.tempLabel.text = [NSString stringWithFormat:@"%d%%",(int)(slider.value / slider.maximumValue * 100)];
}

- (IBAction)donePick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.selectedLED) {
        if (self.addVC.editIndexPath) {
            [self.currentScene.LEDs replaceObjectAtIndex:self.addVC.editIndexPath.row withObject:self.selectedLED];
            [self.currentScene.lights replaceObjectAtIndex:self.addVC.editIndexPath.row withObject:[NSNumber numberWithUnsignedChar:self.selectedLED.currentLight]];
            [self.currentScene.temps replaceObjectAtIndex:self.addVC.editIndexPath.row withObject:[NSNumber numberWithUnsignedChar:self.selectedLED.currentTemp]];
        }
        else
        {
            [self.currentScene.LEDs addObject:self.selectedLED];
            [self.currentScene.lights addObject:[NSNumber numberWithUnsignedChar:self.selectedLED.currentLight]];
            [self.currentScene.temps addObject:[NSNumber numberWithUnsignedChar:self.selectedLED.currentTemp]];
        }
       
        [self.addVC unWindToHere:sender];

    }
}

- (IBAction)cancelPick:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
@end
