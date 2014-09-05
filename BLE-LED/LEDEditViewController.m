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

@import CoreImage;

@interface LEDEditViewController () <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (nonatomic) IBOutlet UIImageView *LEDImageView;
@property (weak, nonatomic) IBOutlet UITextField *LEDNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *QRImageView;
@property (weak, nonatomic) IBOutlet UILabel *QRLabel;

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
    self.QRImageView.image = [self createNonInterpolateduIImageForCIImage:qrImage
                                                                withScale:2 * [UIScreen mainScreen].scale];
    self.QRLabel.text = _editLED.QRCodeString;
    
   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


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


@end
