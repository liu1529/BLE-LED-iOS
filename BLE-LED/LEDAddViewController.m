//
//  LEDAddViewController.m
//  BLE-LED
//
//  Created by xlliu on 14-8-5.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "LEDAddViewController.h"
#import "LEDViewController.h"

@interface LEDAddViewController ()

@property (strong, nonatomic) AVCaptureDevice *captureDevice;
@property (strong, nonatomic) AVCaptureDeviceInput *captureDeviceInput;
@property (strong, nonatomic) AVCaptureMetadataOutput *captureMetadataOutput;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreview;

@property (weak, nonatomic) LEDViewController *listVC;

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
    
    UIViewController *backVC = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
    self.listVC = (LEDViewController *)backVC;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupCamera
{
    self.captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:nil];
    
    self.captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.captureSession canAddInput:self.captureDeviceInput]) {
        [self.captureSession addInput:self.captureDeviceInput];
    }
    if ([self.captureSession canAddOutput:self.captureMetadataOutput]) {
        [self.captureSession addOutput:self.captureMetadataOutput];
    }
    
    self.captureMetadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    self.captureVideoPreview = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.captureVideoPreview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.captureVideoPreview setFrame:self.view.frame];
    [self.view.layer addSublayer:self.captureVideoPreview];
    
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
        if ([self metadataIsVaild:metadata.stringValue])
        {
            [self performSegueWithIdentifier:@"toLEDAddEdit" sender:self];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:metadata.stringValue delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];

        }
    }
}

- (BOOL) metadataIsVaild:(NSString *)metadata
{
  
    NSArray *items = [metadata componentsSeparatedByString:@","];
    
    if (2 != items.count) {
        return NO;
    }
    NSArray *addrItems = [items[0] componentsSeparatedByString:@":"];
    if (6 != addrItems.count) {
        return NO;
    }
    for (NSString *addrItem in addrItems) {
        if (addrItem.intValue > 0xff) {
            return NO;
        }
    }
    
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)unWindToAdd:(id)sender
{
    
}


@end
