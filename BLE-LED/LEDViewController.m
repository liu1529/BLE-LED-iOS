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
#import "LEDAddViewController.h"
#import "AppDelegate.h"
#import "DataModel.h"
#import "UIImage+Tint.h"

@interface LEDViewController ()  <CBPeripheralDelegate>
{
    DataModel *_dataModel;
    LEDItem *_editLED;
    NSMutableArray *_discoverPeripherals;
}

@property (strong, nonatomic) CBCentralManager *centralManager;
@property  BOOL isRefreing;


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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _dataModel = [DataModel sharedDataModel];
        _discoverPeripherals = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self loadInit];

    self.LEDCollectionView.dataSource = self;
    self.LEDCollectionView.delegate = self;
//    self.LEDCollectionView.allowsMultipleSelection = YES;

    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    self.isRefreing = NO;
    

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
        LEDItem *aLED = [LEDItem LEDWithName:[NSString stringWithFormat:@"LED %i", i] Image:[UIImage imageNamed:@"LED0.png"]];
        aLED.blueAddrWithColon = [NSString stringWithFormat:@"00:00:00:00:00:%02d",i];
        [_dataModel addLEDToList:aLED];
    }
    
}

#pragma mark - LongPressGestureRecognizer

- (void) doLongPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:@"Del It"
                                      otherButtonTitles:@"Edit It", nil];
        [actionSheet showInView:self.view];
        
        
        NSIndexPath *index = [self.LEDCollectionView
                              indexPathForItemAtPoint:
                              [sender locationInView:self.LEDCollectionView]];
        
        _editLED = _dataModel.LEDs[index.row];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [_dataModel removeLEDFromList:_editLED];
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
    return _dataModel.LEDs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LEDCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    LEDItem *aLED = _dataModel.LEDs[indexPath.row];
    cell.nameLabel.text = aLED.name;
    
    if (aLED.bluePeripheral) {
        cell.imageView.image = aLED.image;
    }
    else
    {
        cell.imageView.image = [aLED.image imageWithTintColor:[UIColor grayColor]];
    }
    
    switch (aLED.state)
    {
        case LEDStateDisSelected:
            cell.indicatorImageView.hidden = YES;
            cell.indicatorActivityView.hidden = YES;
            break;
        case LEDStateSelecting:
            cell.indicatorActivityView.hidden = NO;
            cell.indicatorImageView.hidden = YES;
            break;
        case LEDStateSelected:
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
    
    LEDItem *currentSelectLED = _dataModel.LEDs[indexPath.row];
    
    if (!currentSelectLED.bluePeripheral) {
        return;
    }
    switch (currentSelectLED.bluePeripheral.state)
    {
        case CBPeripheralStateDisconnected:
            
            currentSelectLED.state = LEDStateSelecting;
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
        
        [_discoverPeripherals removeAllObjects];
        self.isRefreing = YES;
        
        for (LEDItem *LED in _dataModel.LEDs)
        {
            if (CBPeripheralStateDisconnected != LED.bluePeripheral.state) {
                [self.centralManager cancelPeripheralConnection:LED.bluePeripheral];
            }
        }
        [_dataModel clearSelectsLEDs];
        self.lightSlider.enabled = NO;
        self.tempSlider.enabled = NO;
        [self.LEDCollectionView reloadData];
    
        // start progress spinner
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        //add ActiveIndicatorView
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
   
    NSMutableArray *LEDs = _dataModel.LEDs;
    
    if (![peripheral.name isEqualToString:@"Greeble Light"]) {
        return;
    }
    
    for (NSInteger i = 0;i < LEDs.count; i++)
    {
        LEDItem *LED = LEDs[i];
        CBPeripheral *p = LED.bluePeripheral;
        if ([p.identifier isEqual:peripheral.identifier])
        {
            LED.bluePeripheral = peripheral;
            return;
        }
    }
    
    for (CBPeripheral *p in _discoverPeripherals) {
        if ([p.identifier isEqual:peripheral.identifier]) {
            return;
        }
    }
    [_discoverPeripherals addObject:peripheral];
//    LEDItem *aLED = [LEDItem LEDWithName:peripheral.name Image:[UIImage imageNamed:@"LED0.png"]];
//    aLED.bluePeripheral = peripheral;
//    aLED.isValid = YES;
//    
//    [_dataModel addLEDToList:aLED];
//    [self.LEDCollectionView reloadData];
    
    
    printf("discover peripheral %s\n", [peripheral.description UTF8String]);
     [_centralManager connectPeripheral:peripheral options:nil];
   
  
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
    
    if (!error)
    {
        for (LEDItem *aLED in _dataModel.LEDs)
        {
            if (aLED.bluePeripheral == peripheral)
            {
                [_dataModel removeLEDFromSelects:aLED];
                [self.LEDCollectionView reloadData];
                break;
            }
        }
        
        if (_dataModel.selectLEDs.count == 0)
        {
            self.lightSlider.enabled = NO;
            self.tempSlider.enabled = NO;
        }
        
        printf("disconnect peripheral %s\n", [[peripheral.identifier UUIDString] UTF8String]);

        
    }
    else
        printf("disconnect peripheral %s err:%s \n", [[peripheral.identifier UUIDString] UTF8String], [error.description UTF8String]);
}


- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    for (LEDItem *aLED in _dataModel.LEDs)
    {
        if (aLED.bluePeripheral == peripheral)
        {
            aLED.state = LEDStateDisSelected;
            [self.LEDCollectionView reloadData];
            break;
        }
    }
    printf("fail connect peripheral %s err:%s \n", [[peripheral.identifier UUIDString] UTF8String], [error.description UTF8String]);

}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{

}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
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
   
    if (!error)
    {
//        for (LEDItem *aLED in _dataModel.LEDs)
//        {
//            if (aLED.bluePeripheral == peripheral)
//            {
//                
//                aLED.characteristics = service.characteristics;
//                [_dataModel addLEDtoSelects:aLED];
//                [self.LEDCollectionView reloadData];
//                break;
//            }
//        }
        
        for (CBCharacteristic *charac in service.characteristics)
        {
            if ([charac.UUID isEqual:LED_CHAR_ID_UUID] &&
                charac.properties & CBCharacteristicPropertyRead)
            {
                [peripheral readValueForCharacteristic:charac];
            }
        }
        
        
//        self.lightSlider.enabled = YES;
//        self.tempSlider.enabled = YES;
        
        printf("p:%s,s:%s discover characteristics\n",[[peripheral.identifier UUIDString] UTF8String],[service.UUID.data.description  UTF8String]);
    }
    else
        printf("p:%s,s:%s discover characteristics err:%s \n", [[peripheral.identifier UUIDString] UTF8String],[service.UUID.data.description  UTF8String],[error.description UTF8String]);
   
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        printf("!!!p:%s c:%s write err:%s!!!\n",[[peripheral.identifier UUIDString] UTF8String],[characteristic.UUID.data.description UTF8String],[[error description] UTF8String] );
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (!error)
    {
       
        printf("p:%s c:%s read value:%s\n",
               [[peripheral.identifier UUIDString] UTF8String],
               [characteristic.UUID.data.description UTF8String],
               [[characteristic.value description] UTF8String]);
        
        if (characteristic.value.length != 6) {
            [_centralManager cancelPeripheralConnection:peripheral];
            [_discoverPeripherals removeObject:peripheral];
            return;
        }
        
        
        
        __block NSMutableString *recvAddrString = [[NSMutableString alloc] init];
        [characteristic.value enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
            Byte *p = (Byte *)(bytes + byteRange.length - 1);
            for (NSUInteger i = 0; i < byteRange.length; i++) {
                [recvAddrString appendFormat:@"%02X",*p--];
            }
        }];
       
        printf("recv addr string %s \n",[recvAddrString UTF8String]);
        
        NSUInteger i = 0;
        for (;i < _dataModel.LEDs.count; i++)
        {
            LEDItem *aLED = _dataModel.LEDs[i];
            if ([aLED.blueAddr isEqualToString:recvAddrString])
            {
                aLED.bluePeripheral = peripheral;
                aLED.characteristics = [[peripheral.services firstObject] characteristics];
                [self.LEDCollectionView reloadData];
                break;
            }
        }
        if (i >= _dataModel.LEDs.count) {
            [_centralManager cancelPeripheralConnection:peripheral];
        }
    }
    else
    {
        
        [_centralManager cancelPeripheralConnection:peripheral];
        printf("!!!p:%s c:%s read err:%s!!!\n",[[peripheral.identifier UUIDString] UTF8String],[characteristic.UUID.data.description UTF8String],[[error description] UTF8String] );

    }
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (!error) {
        printf("p:%s update RSSI:%i\n",[[peripheral.identifier UUIDString] UTF8String],peripheral.RSSI.intValue);
    }
}


#pragma mark - LED Control

- (IBAction)lightChange:(id)sender {
    UISlider *slider = sender;
    self.lightLabel.text = [NSString stringWithFormat:@"%d%%",(int)(slider.value / slider.maximumValue * 100)];
 
    for (LEDItem *aLED in _dataModel.selectLEDs) {
       
            aLED.currentLight = (int)slider.value;
        
        
    }
}

- (IBAction)tempChange:(id)sender {
    UISlider *slider = sender;
    self.tempLabel.text = [NSString stringWithFormat:@"%d%%",(int)(slider.value / slider.maximumValue * 100)];
    
    for (LEDItem *aLED in _dataModel.selectLEDs) {
        aLED.currentTemp = (int)slider.value;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toLEDEdit"])
    {
        LEDEditViewController *editVC = segue.destinationViewController;
        editVC.editLED = _editLED;
        editVC.completionBlock = ^(BOOL success)
        {
            if (success)
            {
                [self.LEDCollectionView reloadData];
            }
            else
            {
                
            }
            [self.navigationController popToRootViewControllerAnimated:YES];

        };
    }
    else if ([segue.identifier isEqualToString:@"toLEDAdd"])
    {
        LEDAddViewController *addVC = segue.destinationViewController;
        LEDItem *theNewLED = [LEDItem LEDWithName:@"new led" Image:[UIImage imageNamed:@"LED0.png"]];
        addVC.theAddLED = theNewLED;
        addVC.completionBlock = ^(BOOL success)
        {
            if (success)
            {
                [_dataModel addLEDToList:theNewLED];
                
                [self.LEDCollectionView reloadData];
            }
            else
            {
                
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        };
       
        
    }
   
   
    
}








@end
