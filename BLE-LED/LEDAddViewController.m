//
//  LEDAddViewController.m
//  BLE-LED
//
//  Created by xlliu on 14-8-5.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "LEDAddViewController.h"
#import "LEDViewController.h"
#import "LEDEditViewController.h"
#import "DataModel.h"
#import "UIImageEffects.h"

@interface LEDAddViewController ()

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreview;


@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@end

@implementation LEDAddViewController

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
   
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupCamera];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupCamera
{
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!captureDevice) {
        
        UIAlertView *alter = [[UIAlertView alloc]
                              initWithTitle:nil
                              message:@"Please Allow App to Use Camera"
                              delegate:nil
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles: nil];
        [alter show];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    AVCaptureDeviceInput *captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    

    
    //capture
    self.captureSession = [[AVCaptureSession alloc] init];
    
    [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.captureSession canAddInput:captureDeviceInput])
    {
        [self.captureSession addInput:captureDeviceInput];
    }

    if ([self.captureSession canAddOutput:captureMetadataOutput])
    {
        [self.captureSession addOutput:captureMetadataOutput];
    }
    //扫描类型为二维码
    captureMetadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    self.captureVideoPreview = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.captureVideoPreview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    self.captureVideoPreview.frame = self.backImageView.frame;
    [self.view.layer insertSublayer:self.captureVideoPreview atIndex:0];
    

    
    CGFloat w = self.backImageView.frame.size.width;
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, 4)];
    lineImageView.image = [UIImage imageNamed:@"line"];
    [self.backImageView addSubview:lineImageView];
    
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        CGRect frame = lineImageView.frame;
        frame.origin.y = self.backImageView.frame.size.height;
        lineImageView.frame = frame;
    } completion:nil];
    
   [self.captureSession startRunning];
    
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self.captureSession stopRunning];
    [self.captureVideoPreview removeFromSuperlayer];
   
    if (metadataObjects.count > 0)
    {
        AVMetadataMachineReadableCodeObject *metadata = metadataObjects[0];
        NSLog(@"%@",metadata.stringValue);
        
        _addLED.QRCodeString = metadata.stringValue;
        if (_addLED.QRCodeString)
        {
            for (LEDItem *aLED in [DataModel sharedDataModel].LEDs)
            {
                if ([aLED.blueAddr isEqualToString:_addLED.blueAddr])
                {
                    if (self.completionBlock) {
                        self.completionBlock(NO);
                    }
                    
                    NSString *msg = [NSString stringWithFormat:@"LED:%@ have been added in the list",aLED.blueAddr];
                     UIAlertView *alert = [[UIAlertView alloc]
                                           initWithTitle:nil
                                           message:msg
                                           delegate:nil
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:nil];
                    [alert show];
                   
                    return;
                }
            }
            [self performSegueWithIdentifier:@"toLEDAddEdit" sender:self];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:metadata.stringValue delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
            if (self.completionBlock)
            {
                self.completionBlock(NO);
            }

        }
    }
}

- (IBAction)cancelScan:(id)sender
{
    [self.captureSession stopRunning];
    
    if (self.completionBlock) {
        self.completionBlock(NO);
    }
}





#pragma mark - Navigation

- (UIImage *)backgroundImage
{
    
    UIImage *im = [UIImage imageNamed:@"background.png"];
        
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.1)
    {
        // There was a bug in iOS versions 7.0.x which caused vImage buffers
        // created using vImageBuffer_InitWithCGImage to be initialized with data
        // that had the reverse channel ordering (RGBA) if BOTH of the following
        // conditions were met:
        //      1) The vImage_CGImageFormat structure passed to
        //         vImageBuffer_InitWithCGImage was configured with
        //         (kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little)
        //         for the bitmapInfo member.  That is, if you wanted a BGRA
        //         vImage buffer.
        //      2) The CGImage object passed to vImageBuffer_InitWithCGImage
        //         was loaded from an asset catalog.
        //
        // To reiterate, this bug only affected images loaded from asset
        // catalogs.
        //
        // The workaround is to setup a bitmap context, draw the image, and
        // capture the contents of the bitmap context in a new image.
            
        UIGraphicsBeginImageContextWithOptions(im.size, NO, im.scale);
        [im drawAtPoint:CGPointZero];
        im = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    im = [UIImageEffects imageByApplyingLightEffectToImage:im];
    return im;
    

}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toLEDAddEdit"])
    {
        LEDEditViewController *editVC = segue.destinationViewController;
        editVC.isAdd = YES;
        editVC.editLED = self.addLED;
        
       
        UIImageView *iv = [[UIImageView alloc] initWithFrame:self.view.frame];
        iv.image = [self backgroundImage];
        [editVC.view addSubview:iv];
        [editVC.view sendSubviewToBack:iv];
        
        editVC.completionBlock = ^(BOOL success)
        {
            if (self.completionBlock)
            {
                self.completionBlock(success);
                
            }
           
        };
    }
}




@end
