//
//  LEDViewController.m
//  BLE-LED
//
//  Created by xlliu on 14-8-4.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "LEDViewController.h"
#import "TabBarViewController.h"
#import "LEDCollectionCell.h"
#import "LEDEditViewController.h"
#import "AppDelegate.h"

@interface LEDViewController ()  <CBPeripheralDelegate>


@property (nonatomic,strong) NSMutableArray *selectLEDs;
@property (strong, nonatomic) CBCentralManager *centralManager;
@property  BOOL isRefreing;
@property NSMutableArray *allLEDs;


@property (weak, nonatomic) IBOutlet UICollectionView *LEDCollectionView;
@property (weak, nonatomic) IBOutlet UIView *LEDControlView;
@property (weak, nonatomic) IBOutlet UILabel *lightLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UISlider *lightSlider;
@property (weak, nonatomic) IBOutlet UISlider *tempSlider;



- (IBAction)refreshList:(id)sender;

- (IBAction)lightChange:(id)sender;
- (IBAction)tempChange:(id)sender;

@end

@implementation LEDViewController

NSString *kCellID = @"CellLED";                          // UICollectionViewCell storyboard id


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
    self.selectLEDs = [[NSMutableArray alloc] init];
    [self loadInit];

    self.LEDCollectionView.dataSource = self;
    self.LEDCollectionView.delegate = self;
    self.LEDCollectionView.allowsSelection = YES;
//    self.LEDCollectionView.allowsMultipleSelection = YES;
    
   
    self.lightSlider.enabled = NO;
    self.tempSlider.enabled = NO;
    
    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    self.isRefreing = NO;
    
    
    self.allLEDs = ((TabBarViewController *)(self.tabBarController)).allLEDs;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    switch (self.interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            if ([self.LEDCollectionView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
                ((UICollectionViewFlowLayout *)(self.LEDCollectionView.collectionViewLayout)).scrollDirection = UICollectionViewScrollDirectionHorizontal;
            }
            
            break;
        default:
            if ([self.LEDCollectionView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
                ((UICollectionViewFlowLayout *)(self.LEDCollectionView.collectionViewLayout)).scrollDirection = UICollectionViewScrollDirectionVertical;
            }
            break;
    }
}

- (void) loadInit
{
    
    for(int i = 0; i < 8; i++)
    {
        LEDItem *aLED = [[LEDItem alloc] init];
        aLED.image = [UIImage imageNamed:@"LED0.png"];
        aLED.name = [NSString stringWithFormat:@"LED %d", i];
        
        
        [self.allLEDs addObject:aLED];
    }
    
}

#pragma mark - LongPressGestureRecognizer

- (void) doLongPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"Del or edit it?"
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:@"Del It"
                                      otherButtonTitles:@"Edit It", nil];
        [actionSheet showInView:self.view];
        
        
        
        NSIndexPath *index = [self.LEDCollectionView
                              indexPathForItemAtPoint:
                              [sender locationInView:self.LEDCollectionView]];
        
        self.editLED = self.allLEDs[index.row];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self.allLEDs removeObject:self.editLED];
            [self.LEDCollectionView reloadData];
            break;
        case 1:
            [self performSegueWithIdentifier:@"toLEDEdit" sender:self];
            break;
        default:
            break;
    }
}


#pragma mark - CollectonView


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allLEDs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LEDCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    LEDItem *aLED = self.allLEDs[indexPath.row];
    cell.imageView.image = aLED.image;
    cell.nameLabel.text = aLED.name;
    
    switch (aLED.state)
    {
        case LEDStateDisConnected:
            cell.indicatorImageView.hidden = YES;
            cell.indicatorActivityView.hidden = YES;
            break;
        case LEDStateConnecting:
            cell.indicatorActivityView.hidden = NO;
            cell.indicatorImageView.hidden = YES;
            break;
        case LEDStateDiscoverCharacteristics:
            cell.indicatorActivityView.hidden = YES;
            cell.indicatorImageView.hidden = NO;
            break;
        default:
            break;
    }
   
    UILongPressGestureRecognizer *longPressGr =
        [[UILongPressGestureRecognizer alloc]
         initWithTarget:self
         action:@selector(doLongPress:)];
    longPressGr.numberOfTapsRequired = 0;
    
    [cell addGestureRecognizer:longPressGr];
    
    return cell;
}





- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    LEDItem *currentSelectLED = self.allLEDs[indexPath.row];
    
    switch (currentSelectLED.bluePeripheral.state)
    {
        case CBPeripheralStateDisconnected:
            
            currentSelectLED.state = LEDStateConnecting;
            [self.LEDCollectionView reloadData];
            [self.centralManager connectPeripheral:currentSelectLED.bluePeripheral options:nil];
            break;
        case CBPeripheralStateConnected:
            [self.centralManager cancelPeripheralConnection:currentSelectLED.bluePeripheral];
            break;
        default:
            break;
    }
    
}






#pragma mark - LED Refrefing

- (IBAction)refreshList:(id)sender {
    if (self.isRefreing == NO) {
        
        self.isRefreing = YES;
        
        for (LEDItem *LED in self.allLEDs)
        {
            if (CBPeripheralStateConnected == LED.bluePeripheral.state) {
                [self.centralManager cancelPeripheralConnection:LED.bluePeripheral];
            }
        }
        [self.allLEDs removeAllObjects];
        [self.selectLEDs removeAllObjects];
        [self.LEDCollectionView reloadData];
    
        // start progress spinner
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        UIView *activeBackView = [[UIView alloc] initWithFrame:self.view.frame];
        
        activeBackView.backgroundColor =  self.LEDCollectionView.backgroundColor;
        activeBackView.alpha = 0.1;
        [self.view addSubview:activeBackView];
        
        
        UIActivityIndicatorView * activeIndicator = [[UIActivityIndicatorView alloc]
                                                     initWithFrame:CGRectMake(0, 0, 50, 50)];
        activeIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        activeIndicator.color = [UIColor blackColor];
        [activeIndicator setCenter:activeBackView.center];
        
        [activeIndicator startAnimating];
        [activeBackView addSubview:activeIndicator];
        
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(scanTimer:) userInfo:activeBackView repeats:NO];
        
        
        
        
    }
   
}

- (void) scanTimer:(NSTimer *)timer
{
    UIView *activeBackView = timer.userInfo;
    activeBackView.hidden = YES;
    
    [self.centralManager stopScan];
    self.isRefreing = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
 //   [self.LEDCollectionView reloadData];
}

#pragma mark - Bluethooth CentralManager

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            
            break;
            
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
   
    NSMutableArray *LEDs = self.allLEDs;
    
    if (![peripheral.name isEqualToString:@"Greeble Light"]) {
        return;
    }
    
    for (NSInteger i = 0;i < LEDs.count; i++)
    {
        LEDItem *LED = LEDs[i];
        CBPeripheral *p = LED.bluePeripheral;
        int r = [p.identifier isEqual:peripheral.identifier];
        if (1 == r)
        {
            LED.bluePeripheral = peripheral;
            return;
        }
        else if(-1 == r)
        {
            if ([p.name isEqualToString:peripheral.name]) {
                LED.bluePeripheral = peripheral;
                return;
            }
        }
        
    }
    LEDItem *newLED = [LEDItem new];
    newLED.bluePeripheral = peripheral;
    newLED.name = peripheral.name;
    newLED.image = [UIImage imageNamed:@"LED0.png"];
    newLED.state = LEDStateDisConnected;
   
    [LEDs addObject:newLED];
    [self.LEDCollectionView reloadData];
   
    printf("discover peripheral %s\n", [peripheral.description UTF8String]);
   
  
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    
//    [self.lightSlider setValue:aLED.currentLight animated:YES];
//    [self.tempSlider setValue:aLED.currentTemp animated:YES];
//    self.lightLabel.text = [NSString stringWithFormat:@"%d%%",aLED.currentLight];
//    self.tempLabel.text = [NSString stringWithFormat:@"%d%%",aLED.currentTemp];
    
    [peripheral discoverServices:LED_SERVICE_UUIDS];
    
    peripheral.delegate = self;
    
    printf("connect peripheral %s\n", [[peripheral.identifier UUIDString] UTF8String]);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
    for (LEDItem *aLED in self.allLEDs)
    {
        if (aLED.bluePeripheral == peripheral)
        {
            aLED.state = LEDStateDisConnected;
            [self.selectLEDs removeObject:aLED];
            [self.LEDCollectionView reloadData];
            break;
        }
    }
    
    if (self.selectLEDs.count == 0)
    {
        self.lightSlider.enabled = NO;
        self.tempSlider.enabled = NO;
    }
    
    printf("disconnect peripheral %s\n", [[peripheral.identifier UUIDString] UTF8String]);
}


- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{

}

#pragma mark - Bluethooth Peripheral

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    printf("p:%s discover services\n",[[peripheral.identifier UUIDString] UTF8String]);
    for (CBService *service in peripheral.services)
    {
        
        if ([service.UUID isEqual:LED_SERVICE_UUID])
        {
            [peripheral discoverCharacteristics:LED_CHAR_UUIDS forService:service];
            
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
   
    for (LEDItem *aLED in self.allLEDs)
    {
        if (aLED.bluePeripheral == peripheral)
        {
            
            aLED.state = LEDStateDiscoverCharacteristics;
            aLED.characteristics = service.characteristics;
            [self.selectLEDs addObject:aLED];
            [self.LEDCollectionView reloadData];
            break;
        }
    }
    
    self.lightSlider.enabled = YES;
    self.tempSlider.enabled = YES;
    
    printf("p:%s,s:%s discover characteristics\n",[[peripheral.identifier UUIDString] UTF8String],[service.UUID.data.description  UTF8String]);
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        printf("!!!p:%s c:%s err:%s!!!\n",[[peripheral.identifier UUIDString] UTF8String],[characteristic.UUID.data.description UTF8String],[[error description] UTF8String] );
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}


#pragma mark - LED Control

- (IBAction)lightChange:(id)sender {
    UISlider *slider = sender;
    self.lightLabel.text = [NSString stringWithFormat:@"%d%%",(int)(slider.value / slider.maximumValue * 100)];
 
    for (LEDItem *aLED in self.selectLEDs) {
       
            aLED.currentLight = (int)slider.value;
        
        
    }
}

- (IBAction)tempChange:(id)sender {
    UISlider *slider = sender;
    self.tempLabel.text = [NSString stringWithFormat:@"%d%%",(int)(slider.value / slider.maximumValue * 100)];
    
    for (LEDItem *aLED in self.selectLEDs) {
        aLED.currentTemp = (int)slider.value;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toLEDEdit"]) {
       
    }
    else if ([segue.identifier isEqualToString:@"toLEDAdd"])
    {
        
        
    }
   
   
    
}

- (IBAction)unWindToList:(id)sender
{
    [self.LEDCollectionView reloadData];
}






@end
