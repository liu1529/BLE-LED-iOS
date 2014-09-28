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
#import "UIImage+Filter.h"

@interface LEDViewController ()  <UICollectionViewDataSource,
                                UICollectionViewDelegate,
                                UIActionSheetDelegate,
                                CBCentralManagerDelegate,
                                CBPeripheralDelegate>
{
    DataModel *_dataModel;
    NSMutableArray *_discoverPeripherals;
    UICollectionView *_LEDCollectionView;
}

@property (strong, nonatomic) CBCentralManager *centralManager;


- (IBAction)refreshList:(id)sender;


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
    [self loadInit];

    _LEDCollectionView = (UICollectionView *)self.view;
    _LEDCollectionView.dataSource = self;
    _LEDCollectionView.delegate = self;
//    self.LEDCollectionView.allowsMultipleSelection = YES;

    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@(YES)}];
   
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [refreshControl addTarget:self action:@selector(refreshList:) forControlEvents: UIControlEventValueChanged ];
    [_LEDCollectionView addSubview:refreshControl];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setEditing:NO animated:NO];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   

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
            if ([_LEDCollectionView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
                ((UICollectionViewFlowLayout *)(_LEDCollectionView.collectionViewLayout)).scrollDirection = UICollectionViewScrollDirectionHorizontal;
            }
            
            break;
        default:
            if ([_LEDCollectionView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
                ((UICollectionViewFlowLayout *)(_LEDCollectionView.collectionViewLayout)).scrollDirection = UICollectionViewScrollDirectionVertical;
            }
            break;
    }
}

- (void) loadInit
{
    
    for(int i = 0; i < 8; i++)
    {
        LEDItem *aLED = [LEDItem LEDWithName:[NSString stringWithFormat:@"LED %i", i] Image:[UIImage imageNamed:@"LED.png"]];
        aLED.QRCodeString = [NSString stringWithFormat:@"00:00:00:00:00:%02d,%d",i,i];
        [_dataModel addLEDToList:aLED];
    }
    
}


#pragma mark - CollectonView datasource


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataModel.LEDs.count + 1;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LEDCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
//    cell.layer.borderColor = [UIColor blueColor].CGColor;
//    cell.layer.borderWidth = 2;
    
    
    if (indexPath.row >= _dataModel.LEDs.count) {
        cell.imageView.image = [UIImage imageNamed:@"add_icon.png"];
        cell.nameLabel.text = @"scan to add";
        return cell;
    }
    
    LEDItem *aLED = _dataModel.LEDs[indexPath.row];
    cell.nameLabel.text = aLED.name;
    cell.imageView.image = aLED.bluePeripheral ? aLED.image : [aLED.image withFilterName: @"CIPhotoEffectMono"];
    
   
    return cell;
}



# pragma mark - CollectonView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= _dataModel.LEDs.count) {
        [self performSegueWithIdentifier:@"toLEDAdd" sender:indexPath];
        return;
    }
    
    [self performSegueWithIdentifier:@"toLEDEdit" sender:indexPath];

}






#pragma mark - LED Refrefing

- (IBAction)refreshList:(id)sender {
//    if ([sender isRefreshing] == NO)
    {
        
        [_discoverPeripherals removeAllObjects];
        
        for (LEDItem *LED in _dataModel.LEDs)
        {
            if (LED.bluePeripheral) {
                [self.centralManager cancelPeripheralConnection:LED.bluePeripheral];
            }
          
        }
        

        [_LEDCollectionView reloadData];
    
        // start progress spinner
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];

        [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(scanTimer:) userInfo:sender repeats:NO];
        
    }
   
}

- (void) scanTimer:(NSTimer *)timer
{

    [self.centralManager stopScan];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
  
    UIRefreshControl *refreshControl = timer.userInfo;
    [refreshControl endRefreshing];

    
  
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
   
    NSArray *LEDs = _dataModel.LEDs;
    
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

    printf("discover peripheral %s\n", [peripheral.description UTF8String]);
     [_centralManager connectPeripheral:peripheral
                                options:
                                    @{
                                      CBConnectPeripheralOptionNotifyOnConnectionKey: @(YES),
                                      CBConnectPeripheralOptionNotifyOnDisconnectionKey: @(YES)
                                      }];
   
  
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
    [_discoverPeripherals removeObject:peripheral];
    for (LEDItem *aLED in _dataModel.LEDs)
    {
        if (aLED.bluePeripheral == peripheral)
        {
            aLED.bluePeripheral = nil;
            [_LEDCollectionView reloadData];
            break;
        }
    }
    

    
    if (!error)
    {
        printf("disconnect peripheral %s\n", [[peripheral.identifier UUIDString] UTF8String]);

        
    }
    else
        printf("disconnect peripheral %s err:%s \n", [[peripheral.identifier UUIDString] UTF8String], [error.description UTF8String]);
}


- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [_discoverPeripherals removeObject:peripheral];
    for (LEDItem *aLED in _dataModel.LEDs)
    {
        if (aLED.bluePeripheral == peripheral)
        {
            aLED.bluePeripheral = nil;
            aLED.state = LEDStateDisSelected;
            [_LEDCollectionView reloadData];
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
    if (error) {
        [_discoverPeripherals removeObject:peripheral];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
   
    if (!error)
    {
        
        for (CBCharacteristic *charac in service.characteristics)
        {
            if ([charac.UUID isEqual:LED_CHAR_ID_UUID] &&
                charac.properties & CBCharacteristicPropertyRead)
            {
                [peripheral readValueForCharacteristic:charac];
            }
        }
        
        printf("p:%s,s:%s discover characteristics\n",[[peripheral.identifier UUIDString] UTF8String],[service.UUID.data.description  UTF8String]);
    }
    else
    {
        printf("p:%s,s:%s discover characteristics err:%s \n", [[peripheral.identifier UUIDString] UTF8String],[service.UUID.data.description  UTF8String],[error.description UTF8String]);
        [_discoverPeripherals removeObject:peripheral];
    }
    
   
    
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
    [_discoverPeripherals removeObject:peripheral];
    
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
        __block NSMutableData *recvAddrData = [[NSMutableData alloc] init];
        [characteristic.value enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
            Byte *p = (Byte *)(bytes + byteRange.length - 1);
            for (NSUInteger i = 0; i < byteRange.length; i++) {
                [recvAddrData appendBytes:p length:1];
                [recvAddrString appendFormat:@"%02X",*p--];
                
            }
        }];
       
        NSLog(@"%@",recvAddrData);
        printf("recv addr string %s \n",[recvAddrString UTF8String]);
        
        NSUInteger i = 0;
        for (;i < _dataModel.LEDs.count; i++)
        {
            LEDItem *aLED = _dataModel.LEDs[i];
            if ([aLED.blueAddr isEqualToString:recvAddrString])
            {
                aLED.bluePeripheral = peripheral;
                aLED.characteristics = [[peripheral.services firstObject] characteristics];
                [_LEDCollectionView reloadData];
                [aLED writeConfirmation:[recvAddrData subdataWithRange:NSMakeRange(3, 3)]];
                aLED.identifier = peripheral.identifier;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toLEDEdit"])
    {
        LEDEditViewController *editVC = segue.destinationViewController;
        editVC.editLED = _dataModel.LEDs[[sender row]];

        editVC.completionBlock = ^(BOOL success)
        {
            if (success)
            {
                [_LEDCollectionView reloadData];
                [_dataModel saveData];
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
        LEDItem *aLED = [LEDItem LEDWithName:@"new light" Image:[UIImage imageNamed:@"LED.png"]];
        addVC.addLED = aLED;
       
        addVC.completionBlock = ^(BOOL success)
        {
            if (success)
            {
                [_dataModel addLEDToList:aLED];
                [_LEDCollectionView reloadData];
                [_dataModel saveData];
            }
            else
            {
                
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        };
       
        
    }
   
   
    
}








@end
