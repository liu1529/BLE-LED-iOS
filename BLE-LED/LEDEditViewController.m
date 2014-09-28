//
//  LEDEditViewController.m
//  BLE-LED
//
//  Created by xlliu on 14-8-4.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "LEDEditViewController.h"
#import "ImageCollectionCell.h"
#import "TabBarViewController.h"
#import "LEDAddViewController.h"
#import "LEDEditTableViewCell.h"
#import "LEDEditTableViewQRCell.h"
#import "LEDEditTableHeader.h"

#import <UIKit/UIView.h>

@import CoreImage;

@interface LEDEditViewController () <UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSTimer *_updateRSSITimer;
    BOOL _LEDIsExpand;
    BOOL _QRIsExpand;
    UIImage *_QRImage;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UIImageView *LEDImageView;
@property (weak, nonatomic) IBOutlet UITextField *LEDNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *QRImageView;
@property (weak, nonatomic) IBOutlet UILabel *QRLabel;
@property (weak, nonatomic) IBOutlet UILabel *RSSILabel;
@property (weak, nonatomic) IBOutlet UISwitch *LEDSwitch;
@property (weak, nonatomic) IBOutlet UISlider *lightSlider;
@property (weak, nonatomic) IBOutlet UISlider *tempSlider;

- (IBAction)hideKeyboard:(id)sender;
- (IBAction)doneEdit:(id)sender;
- (IBAction)cancelEdit:(id)sender;


@property (weak,nonatomic) LEDViewController *listViewController;
@property (weak,nonatomic) LEDAddViewController *addViewController;
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
    self.QRImageView.image = _QRImage;
    self.QRLabel.text = _editLED.QRCodeString;
    
    if (!_editLED.bluePeripheral) {
        _LEDSwitch.on = NO;
        _LEDSwitch.enabled = NO;
    }
    
    _lightSlider.enabled = _LEDSwitch.on;
    _tempSlider.enabled = _LEDSwitch.on;
    
    
    if (_editLED.bluePeripheral) {
        _RSSILabel.text = @"Reading";
        [_editLED.bluePeripheral readRSSI];
        _updateRSSITimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateRSSI) userInfo:nil repeats:YES];
    }
    
    
    
    _LEDIsExpand = NO;
    _QRIsExpand = NO;
    
    
    
   
}

- (void) updateRSSI
{
    if (_editLED.bluePeripheral) {
        if (_editLED.bluePeripheral.RSSI) {
            _RSSILabel.text = [NSString stringWithFormat:@"%@ DB",_editLED.bluePeripheral.RSSI];
        }
        [_editLED.bluePeripheral readRSSI];

    }
    else
    {
        _LEDSwitch.enabled = NO;
        _lightSlider.enabled = _LEDSwitch.on;
        _tempSlider.enabled = _LEDSwitch.on;
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
    
    CIFilter *qfFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qfFilter setDefaults];
    
    [qfFilter setValue:stringData forKey:@"inputMessage"];
    [qfFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    return qfFilter.outputImage;
}

- (UIImage *)createNonInterpolateduIImageForCIImage:(CIImage *)image withScale:(CGFloat) scale
{
    CGFloat width = image.extent.size.width * scale;
    CGFloat height = image.extent.size.height * scale;
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    
    UIImage *aImage = [UIImage imageWithCGImage:cgImage scale:0.1 orientation:UIImageOrientationUp];
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    [aImage drawInRect:CGRectMake(0, 0, width, height)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    
    
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
        return _QRIsExpand ? 1 : 0;
    }
    else if(section == 1)
    {
        return _LEDIsExpand ? 2 : 0;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    if (indexPath.section == 0) {
        LEDEditTableViewQRCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LEDEditTableQRCell" forIndexPath:indexPath];
        
        cell.qrImageView.image = _QRImage;
        cell.qrString.text = _editLED.QRCodeString;
        
        return cell;
    }
    else if(indexPath.section == 1)
    {
        LEDEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LEDEditTableCtrlCell" forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:
                cell.label.text = @"Lumen:";
                [cell.slider addTarget:self action:@selector(lightChange:) forControlEvents:UIControlEventValueChanged];
                break;
            case 1:
                cell.label.text = @"CCT:";
                [cell.slider addTarget:self action:@selector(tempChange:) forControlEvents:UIControlEventValueChanged];
                break;
            default:
                break;
        }
        return cell;
    }
    
    return nil;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 300;
    }
    else if(indexPath.section == 1)
    {
        return 75;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    UISwitch *s = [UISwitch new];
    return s.frame.size.height + 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *h = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    
    if (!h) {
        h = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"Header"];
    }
    
    if (h.tag != 1) {
        h.tag = 1;
        NSLog(@"new header");
        
        if (section == 0) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            //btn.backgroundColor = [UIColor blueColor];
            [btn setTitle:@"QRImage" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.textAlignment = NSTextAlignmentLeft;
//            UILabel *label = [UILabel new];
//            label.text = @"QRCodeImage";
            [h.contentView addSubview:btn];
            
            UIImage *im = [UIImage imageNamed:@"expandableImage"];
            UIImageView *iv = [UIImageView new];
            iv.contentMode = UIViewContentModeCenter;
            iv.image = im;
            [h.contentView addSubview:iv];
            
            
            btn.translatesAutoresizingMaskIntoConstraints = NO;
            iv.translatesAutoresizingMaskIntoConstraints = NO;
            NSDictionary *vs = NSDictionaryOfVariableBindings(btn,iv);
            
//            [h.contentView addConstraints:
//             [NSLayoutConstraint
//              constraintsWithVisualFormat:
//              @"H:|-[btn]-|"
//              options:0 metrics:nil views:vs]];
            
//            [h.contentView addConstraints:
//             [NSLayoutConstraint
//              constraintsWithVisualFormat:
//              @"H:|-[btn(>=100)]-(>=10)-[iv]-(30)-|"
//              options:0 metrics:nil views:vs]];
            [h.contentView addConstraints:
             [NSLayoutConstraint
              constraintsWithVisualFormat:
              @"H:|-[btn]-|"
              options:0 metrics:nil views:vs]];
            [h.contentView addConstraints:
             [NSLayoutConstraint
              constraintsWithVisualFormat:
              @"H:[iv]-(30)-|"
              options:0 metrics:nil views:vs]];
            
            [h.contentView addConstraints:
             [NSLayoutConstraint
              constraintsWithVisualFormat:
              @"V:|[btn]|"
              options:0 metrics:nil views:vs]];
            [h.contentView addConstraints:
             [NSLayoutConstraint
              constraintsWithVisualFormat:
              @"V:|[iv]|"
              options:0 metrics:nil views:vs]];
            
            [btn addTarget:self action:@selector(QRimageExpand) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
        else if (section == 1)
        {
            UILabel *label = [UILabel new];
            label.text = @"Switch";
            [h.contentView addSubview:label];
            
            UISwitch *s = [UISwitch new];
            s.tag = 2;
            [h.contentView addSubview:s];
            
            
            label.translatesAutoresizingMaskIntoConstraints = NO;
            s.translatesAutoresizingMaskIntoConstraints = NO;
            NSDictionary *vs = NSDictionaryOfVariableBindings(label,s);
            
            [h.contentView addConstraints:
             [NSLayoutConstraint
              constraintsWithVisualFormat:
              @"H:|-[label]->=5@100-[s]-|"
              options:0 metrics:nil views:vs]];
            [h.contentView addConstraints:
             [NSLayoutConstraint
              constraintsWithVisualFormat:
              @"V:|[label]|"
              options:0 metrics:nil views:vs]];
            [h.contentView addConstraints:
             [NSLayoutConstraint
              constraintsWithVisualFormat:
              @"V:|[s]|"
              options:0 metrics:nil views:vs]];
            
            [s addTarget:self action:@selector(LEDSwitch:) forControlEvents:UIControlEventValueChanged];
            s.on = _LEDIsExpand;

        }
    }
        
    return h;
}



-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}



#pragma mark - LED Control Panle

- (void)QRimageExpand
{
    _QRIsExpand = !_QRIsExpand;
    [_tableView reloadData];
}

- (IBAction)LEDSwitch:(UISwitch *)sender
{
    UITableViewHeaderFooterView *h = [_tableView headerViewForSection:1];
    if (h) {
       
        UISwitch *s = (UISwitch *)[h.contentView viewWithTag:2];
        _LEDIsExpand = s.on;
 //       [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView reloadData];
    }
   
}

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
