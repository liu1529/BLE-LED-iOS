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

@interface LEDAddViewController ()
{
    NSTimer *_scanTimer;
}

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreview;


@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *scanLineImageView;

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
   
    [self setupCamera];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   
    
    
   

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    [self.captureSession stopRunning];
    [_scanTimer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupCamera
{
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
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
    
     _scanTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(scanTimer:) userInfo:nil repeats:YES];
    [self.captureSession startRunning];
    
}

- (void) scanTimer:(NSTimer *)timer
{
    CGRect backFrame = self.backImageView.frame;
    static CGFloat yLine = 0;
    static BOOL directDown = YES;
    
    if (directDown)
    {
        yLine += 2;
        if (yLine >= backFrame.size.height)
        {
            yLine = backFrame.size.height;
            directDown = !directDown;
        }
    }
    else
    {
       
        yLine -= 2;
        if (yLine <= 0) {
            yLine = 0;
            directDown = !directDown;
        }

    }
    self.scanLineImageView.frame = CGRectMake(
                                              backFrame.origin.x,
                                              backFrame.origin.y + yLine,
                                              self.scanLineImageView.frame.size.width,
                                              self.scanLineImageView.frame.size.height);
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self.captureSession stopRunning];
    [self.captureVideoPreview removeFromSuperlayer];
    [_scanTimer invalidate];
    if (metadataObjects.count > 0)
    {
        AVMetadataMachineReadableCodeObject *metadata = metadataObjects[0];
        NSLog(@"%@",metadata.stringValue);
        if ([self metadataIsVaild:metadata.stringValue])
        {
            self.theAddLED.blueAddrWithColon = [self metadataGetAddr:metadata.stringValue];
            if (self.theAddLED.blueAddrWithColon == nil) {
                return;
            }
            self.theAddLED.name = [self metadataGetName:metadata.stringValue];

            
            for (LEDItem *aLED in [DataModel sharedDataModel].LEDs)
            {
                if ([aLED.blueAddr isEqualToString:self.theAddLED.blueAddr])
                {
                    
                    NSString *msg = [NSString stringWithFormat:@"LED:%@ have been added in the list",aLED.blueAddr];
                     UIAlertView *alert = [[UIAlertView alloc]
                                           initWithTitle:nil
                                           message:msg
                                           delegate:nil
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:nil];
                    [alert show];
                    if (self.completionBlock) {
                        self.completionBlock(NO);
                    }
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



- (BOOL) metadataIsVaild:(NSString *)metadata
{
  
    NSArray *items = [metadata componentsSeparatedByString:@","];
    
    if (2 != items.count) {
        return NO;
    }
    return YES;
}

- (NSString *) metadataGetAddr:(NSString *)metadata
{
    NSArray *items = [metadata componentsSeparatedByString:@","];
    return items[0];
}

- (NSString *) metadataGetName:(NSString *)metadata
{
    NSArray *items = [metadata componentsSeparatedByString:@","];
    return items[1];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toLEDAddEdit"])
    {
        LEDEditViewController *editVC = segue.destinationViewController;
        editVC.editLED = self.theAddLED;
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
