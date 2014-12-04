//
//  LEDEditViewController.m
//  BLE-LED
//
//  Created by xlliu on 14-8-4.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "LEDEditViewController.h"
#import "ImageCollectionCell.h"
#import "LEDAddViewController.h"
#import "LEDEditTableViewCell.h"
#import "LEDEditTableViewQRCell.h"
#import "LEDEditTableHeader.h"
#import "DataModel.h"

#import <UIKit/UIView.h>

@import CoreImage;

@interface LEDEditViewController () <UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSTimer *_updateRSSITimer;
    BOOL _iSQRExpand;
    UIImage *_QRImage;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UIImageView *LEDImageView;
@property (weak, nonatomic) IBOutlet UITextField *LEDNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *RSSILabel;


- (IBAction)hideKeyboard:(id)sender;
- (IBAction)doneEdit:(id)sender;
- (IBAction)cancelEdit:(id)sender;


@property (strong,nonatomic) NSMutableArray *allImages;


@end

@implementation LEDEditViewController

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
    
    //set collectionview delegate

    //init allImages array
    self.allImages = [DataModel sharedDataModel].imageDic[@"LEDImages"];
    
    self.LEDImageView.image = self.editLED.image;
    self.LEDNameLabel.text = self.editLED.name;
    
    
    CIImage *qrImage = [self createQRForString:_editLED.QRCodeString];
    _QRImage = [self createNonInterpolateduIImageForCIImage:qrImage
                                                  withScale:3 * [UIScreen mainScreen].scale];
    
    
    if (_editLED.bluePeripheral) {
        _RSSILabel.text = @"Reading";
        [_editLED.bluePeripheral readRSSI];
        _updateRSSITimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateRSSI) userInfo:nil repeats:YES];
    }
    
    
    
    _iSQRExpand = NO;
    
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"OnOffCell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"QRCell"];
   
}

- (void) updateRSSI
{
    if (_editLED.bluePeripheral) {
        if (_editLED.bluePeripheral.RSSI) {
            _RSSILabel.text = [NSString stringWithFormat:@"%@ dBm",_editLED.bluePeripheral.RSSI];
        }
        [_editLED.bluePeripheral readRSSI];

    }
    else
    {
        _RSSILabel.text = @"Not Connect";
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setToolbarHidden:_isAdd animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_updateRSSITimer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - QR Code Create

- (CIImage *) createQRForString:(NSString *)qrString
{
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setDefaults];
    
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    
    return qrFilter.outputImage;
}

- (UIImage *)createNonInterpolateduIImageForCIImage:(CIImage *)image withScale:(CGFloat) scale
{
    UIImage *im = [UIImage imageWithCIImage:image];
    UIGraphicsBeginImageContext(CGSizeMake(im.size.width * scale, im.size.height * scale));
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(con, kCGInterpolationNone);
    [im drawInRect:CGRectMake(0, 0, im.size.width * scale, im.size.height * scale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}


#pragma mark - buttons


- (IBAction)hideKeyboard:(id)sender {
    [self.LEDNameLabel resignFirstResponder];
}

- (IBAction)cancelEdit:(id)sender
{
    if (self.completionBlock) {
        self.completionBlock(NO);
    }
}

- (IBAction)doneEdit:(id)sender {

   
    self.editLED.image = self.LEDImageView.image;
    self.editLED.name = self.LEDNameLabel.text;

    if (self.completionBlock) {
        self.completionBlock(YES);
    }
    
}

- (IBAction)transhLED:(id) sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Delete LED"
                                  otherButtonTitles:nil];
    [actionSheet showFromBarButtonItem:sender animated:YES];
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[DataModel sharedDataModel] removeLEDFromList:self.editLED];
        if (self.completionBlock) {
            self.completionBlock(YES);
        }
    }
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _editLED.onOff ? 3 : 1;
    }
    if (section == 1) {
        return _iSQRExpand ? 2 : 1;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OnOffCell" forIndexPath:indexPath];
            cell.textLabel.text = @"On/Off";
            UISwitch *s = [UISwitch new];
            s.on = _editLED.onOff;
            [s addTarget:self action:@selector(onOffButton:withEvent:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = s;
            
            cell.backgroundColor = [UIColor clearColor];
            
            return cell;
        }
        else {
            LEDEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LEDEditTableCtrlCell" forIndexPath:indexPath];
            switch (indexPath.row) {
                case 1:
                    cell.label.text = @"Lumen:";
                    [cell.slider setMinimumValue:LED_LIGHT_MIN];
                    [cell.slider setMaximumValue:LED_LIGHT_MAX];
                    [cell.slider setValue:(float)(_editLED.currentLight) animated:YES];
                    [cell.slider addTarget:self action:@selector(lightChange:) forControlEvents:UIControlEventValueChanged];
                    
                    
                    break;
                case 2:
                    cell.label.text = @"CCT:";
                    [cell.slider setMinimumValue:LED_TEMP_MIN];
                    [cell.slider setMaximumValue:LED_TEMP_MAX];
                    [cell.slider setValue:(float)(_editLED.currentTemp) animated:YES];
                    [cell.slider addTarget:self action:@selector(tempChange:) forControlEvents:UIControlEventValueChanged];
                    break;
                default:
                    break;
            }
            
            cell.backgroundColor = [UIColor clearColor];
            
            return cell;
            
        }
        

    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QRCell" forIndexPath:indexPath];
            cell.textLabel.text = @"QRImage";
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            
            cell.backgroundColor = [UIColor clearColor];
            
            return cell;
        }
        else {
            LEDEditTableViewQRCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LEDEditTableQRCell" forIndexPath:indexPath];
            
            cell.qrImageView.image = _QRImage;
            cell.qrString.text = _editLED.QRCodeString;
            
            cell.backgroundColor = [UIColor clearColor];
            
            return cell;
            
        }

    }
    
    
    return nil;
   
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger heghits[][3] = {
        {40,50,50},
        {40,280,0}};
    return heghits[indexPath.section][indexPath.row];
}

- (void) onOffButton:(UISwitch *)s withEvent:(UIControlEvents *)event
{
    _editLED.onOff = s.on;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}



- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    _iSQRExpand = !_iSQRExpand;
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [tableView reloadData];
}



#pragma mark - LED Control Panle





- (IBAction)lightChange:(UISlider *)sender
{
    _editLED.currentLight = sender.value;
}

- (IBAction)tempChange:(UISlider *)sender
{
    _editLED.currentTemp = sender.value;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
