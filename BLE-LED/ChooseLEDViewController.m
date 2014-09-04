//
//  ChooseLEDViewController.m
//  BLE-LED
//
//  Created by xlliu on 14-8-7.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "ChooseLEDViewController.h"
#import "TabBarViewController.h"
#import "SceneEditViewController.h"
#import "SceneListViewController.h"
#import "DataModel.h"

@interface ChooseLEDViewController () <UIActionSheetDelegate>
{
    NSMutableArray *_validLEDs;
}
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UILabel *lightLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UISlider *lightSlider;
@property (weak, nonatomic) IBOutlet UISlider *tempSlider;


@property (weak, nonatomic) LEDItem *selectedLED;


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
    
    _validLEDs = [[NSMutableArray alloc] initWithArray:[DataModel sharedDataModel].LEDs];
    
    for (LEDItem *LED in self.editScene.LEDs)
    {
        [_validLEDs removeObject:LED];
    }
    if (_editLEDIndex) {
        [_validLEDs insertObject:_editScene.LEDs[_editLEDIndex.row] atIndex:0];
    }
    

    [self.navigationController setToolbarHidden:_isAdd animated:YES];
   
    
    
    if (_validLEDs.count > 0)
    {
        self.selectedLED = _validLEDs[0];
        
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
  
    return _validLEDs.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return [self.view bounds].size.height / 4;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CGRect bounds = [self.view bounds];
    LEDItem *LED = _validLEDs[row];
    UIView *aView = [[UIView alloc]
                     initWithFrame:CGRectMake(
                                              0,
                                              0,
                                              bounds.size.width,
                                              bounds.size.height / 4)];
    
    UIImageView *imageView = [[UIImageView alloc]
                              initWithFrame:CGRectMake(
                                                       0,
                                                       0,
                                                       aView.frame.size.width / 2,
                                                       aView.frame.size.height)];
    imageView.image = LED.image;

    
    
    UILabel *label = [[UILabel alloc]
                      initWithFrame:CGRectMake(
                                               aView.frame.size.width / 2,
                                               0,
                                               aView.frame.size.width / 2,
                                               aView.frame.size.height)];
    label.text = LED.name;
    [label setTextAlignment:NSTextAlignmentCenter];
    label.adjustsFontSizeToFitWidth = YES;
    
    [aView addSubview:label];
    [aView addSubview:imageView];
    
    
   
    
    return aView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_validLEDs.count > 0) {
        self.selectedLED = _validLEDs[row];
        [self.lightSlider setValue:self.selectedLED.currentLight animated:YES];
        [self.tempSlider setValue:self.selectedLED.currentTemp animated:YES];
        
        self.lightLabel.text = [NSString stringWithFormat:
                                @"%d%%",(int)(self.selectedLED.currentLight / self.lightSlider.maximumValue * 100)];
        self.tempLabel.text = [NSString stringWithFormat:
                               @"%d%%",(int)(self.selectedLED.currentTemp / self.tempSlider.maximumValue * 100)];
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
    
    if (!_isAdd)
    {
        [self.editScene replaceLEDAtIndex:_editLEDIndex.row withLED:_selectedLED];
    }
    else
    {
        if (self.selectedLED) {
            [self.editScene addLED:self.selectedLED];
        }
    }
    if (self.completionBlock) {
        self.completionBlock(YES);
    }
    
}

- (IBAction)cancelPick:(id)sender {
    
}

- (IBAction)transhLED:(id)sender
{
   
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Delete LED from scene"
                                  otherButtonTitles:nil];
    [actionSheet showFromBarButtonItem:sender animated:YES];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.editScene removeLEDAtIndexe:_editLEDIndex.row];
        if (self.completionBlock) {
            self.completionBlock(YES);
        }
    }
}



@end
