//
//  LEDViewController.m
//  BLE-LED
//
//  Created by xlliu on 14-8-4.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "LEDViewController.h"
#import "LEDCollectionCell.h"
#import "LEDEditViewController.h"
#import "LEDAddViewController.h"
#import "AppDelegate.h"
#import "DataModel.h"
#import "UIImage+Filter.h"
#import "UIImageEffects.h"


@interface LEDViewController ()  <UICollectionViewDataSource,
                                UICollectionViewDelegate,
                                UIActionSheetDelegate,
                                CBCentralManagerDelegate,
                                CBPeripheralDelegate,
                                UIScrollViewDelegate>
{
    DataModel *_dataModel;
    NSMutableArray *_discoverPeripherals;
    NSArray *_ADImages;
    
}

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (weak, nonatomic) IBOutlet UICollectionView *LEDCollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *ADScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *ADPageControl;

//@property (strong, nonatomic) UIImageView *snapshortImageView;

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
   // [self loadInit];

    _LEDCollectionView.dataSource = self;
    _LEDCollectionView.delegate = self;
    
    
//    self.LEDCollectionView.allowsMultipleSelection = YES;
    
   
    //如果为YES，scrollview会向下偏移64
   // self.automaticallyAdjustsScrollViewInsets = NO;
   // self.edgesForExtendedLayout = UIRectEdgeNone;
   // self.extendedLayoutIncludesOpaqueBars = NO;
    
    [self ADViewInit];
    
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

#pragma mark - ADView

- (void) ADViewInit
{
    CGFloat w = self.ADScrollView.bounds.size.width;
    CGFloat h = self.ADScrollView.bounds.size.height;
    
    //在7.04(11B554a)版本不加下面的值，scrollview会出现不对齐，其他版本未测试
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.1) {
        w += 16;
        h += 9;
    }
    
    
    _ADImages = @[
                  [UIImage imageNamed:@"ad0.png"],
                  [UIImage imageNamed:@"ad1.png"],
                  [UIImage imageNamed:@"ad2.png"]
                  ];
    
    
    
    self.ADScrollView.contentSize = CGSizeMake(_ADImages.count * w, h);
//    self.ADScrollView.layer.borderColor = [UIColor redColor].CGColor;
//    self.ADScrollView.layer.borderWidth = 1;
    
    
    
    self.ADPageControl.numberOfPages = _ADImages.count;
    [self.ADPageControl addTarget:self action:@selector(ADPageUpade) forControlEvents:UIControlEventValueChanged];
    [self.ADPageControl.superview bringSubviewToFront:self.ADPageControl];
    
    
    for (int i = 0; i < _ADImages.count; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(w * i, 0, w, h)];
        
//        iv.layer.borderWidth = 1;
//        iv.layer.borderColor = [UIColor greenColor].CGColor;
        iv.image = _ADImages[i];
        [self.ADScrollView addSubview:iv];
    }
    
    
}

- (void) ADPageUpade
{
    CGFloat w = self.ADScrollView.frame.size.width;
    CGFloat h = self.ADScrollView.frame.size.height;
    [self.ADScrollView scrollRectToVisible:CGRectMake(w * self.ADPageControl.currentPage, 0, w, h) animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat w = self.ADScrollView.frame.size.width;
//    CGFloat h = self.ADScrollView.frame.size.height;

    int currentPage = floor((scrollView.contentOffset.x - w / 2) / w) + 1;
    self.ADPageControl.currentPage = currentPage;
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%f,%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    
    
//    CGFloat w = self.ADScrollView.frame.size.width;
//    CGFloat h = self.ADScrollView.frame.size.height;
//    
//    if (scrollView.contentOffset.x == 0) {
//        CGRect rect = CGRectMake(w * (_ADImages.count - 1), 0, w, h);
//        [scrollView scrollRectToVisible:rect animated:YES];
//    }
//    if (scrollView.contentOffset.x == w * (_ADImages.count - 1)) {
//        CGRect rect = CGRectMake(0, 0, w, h);
//        [scrollView scrollRectToVisible:rect animated:YES];
//    }

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
        cell.nameLabel.text = @"Add";
        return cell;
    }
    
    LEDItem *aLED = _dataModel.LEDs[indexPath.row];
    cell.nameLabel.text = aLED.name;
    if (aLED.bluePeripheral) {
        cell.imageView.image = aLED.image;
    }
    else {
        cell.imageView.image = [aLED.image withFilterName: @"CIPhotoEffectMono"];
    }
    
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
        UIRefreshControl *refreshControl = sender;
        if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:@"Please Trun On Bluethooth to Allow App to Connect to Accessories"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            [refreshControl endRefreshing];
            return;
            
        }
        
        // start progress spinner
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        //取消所有正在连接的
        for (CBPeripheral *p in _discoverPeripherals) {
            [self.centralManager cancelPeripheralConnection:p];
        }
        [_discoverPeripherals removeAllObjects];
        
        /*
        //是否所有的led都成功连接过
        NSMutableArray *identifers = [NSMutableArray array];
        for (LEDItem *led in _dataModel.LEDs) {
            if (led.identifier)
                [identifers addObject:led.identifier];
        }
        //有连接过的
        if (identifers.count > 0) {
            NSArray *retrievePeripherals = [self.centralManager retrievePeripheralsWithIdentifiers:identifers];
            [_discoverPeripherals addObjectsFromArray:retrievePeripherals];
            //再次连接以前连接过得
            for (CBPeripheral *p in retrievePeripherals) {
                [self.centralManager connectPeripheral:p options:nil];
            }
            if (retrievePeripherals.count  == _dataModel.LEDs.count) {
                [refreshControl endRefreshing];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                return;
            }
        }
        */
        //开始扫描
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        
        //扫描5s开始连接
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.centralManager stopScan];
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            [refreshControl endRefreshing];

            for (CBPeripheral *p in _discoverPeripherals) {
                //连接led
                [self.centralManager connectPeripheral:p options:nil];
                
                
                //给每个正在连接的led闪烁提示正在连接
                for (int i = 0; i < _dataModel.LEDs.count; i++) {
                    LEDItem *led = _dataModel.LEDs[i];
                    if ([led.identifier isEqual:p.identifier]) {
                        led.state = LEDStateConecting;
//                        [_LEDCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
                        LEDCollectionCell *cell = (LEDCollectionCell *)[_LEDCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                        cell.alpha = 0.1;
                        [UIView
                         animateWithDuration:2
                         delay:0
                         options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                         animations:^{
                            cell.alpha = 1.0;
                        } completion:^(BOOL finished) {
                            
                        }];
                    }
                }
                
            }
            
            //5s后停止显示刷新
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [refreshControl endRefreshing];
                
            });
            
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_LEDCollectionView reloadData];
        });
        
    }
   
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
   
    
    
    NSString *name = [peripheral.name stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([name localizedCaseInsensitiveCompare:@"GreebleLight"] != NSOrderedSame) {
        return;
    }
    
    for (int i = 0; i < _discoverPeripherals.count; i++) {
        CBPeripheral *p = _discoverPeripherals[i];
        if ([p.identifier isEqual:peripheral.identifier]) {
            _discoverPeripherals[i] = peripheral;
        }
    }
    
    [_discoverPeripherals addObject:peripheral];


    printf("discover peripheral %s\n", [peripheral.description UTF8String]);
  
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral discoverServices:LED_SERVICE_UUIDS];
    
    peripheral.delegate = self;
    
    printf("connect peripheral %s\n", [[peripheral.identifier UUIDString] UTF8String]);
    
}

- (void) processDisconnectPeripheral:(CBPeripheral *)peripheral
{
    [self.centralManager cancelPeripheralConnection:peripheral];
    [_discoverPeripherals removeObject:peripheral];
    for (int i = 0; i < _dataModel.LEDs.count; i++) {
        LEDItem *led = _dataModel.LEDs[i];
        if (led.bluePeripheral == peripheral) {
            led.bluePeripheral = nil;
            [_LEDCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
            break;
        }
    }
    

}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self processDisconnectPeripheral:peripheral];
    
    if (!error)
    {
        printf("disconnect peripheral %s\n", [[peripheral.identifier UUIDString] UTF8String]);

        
    }
    else
        printf("disconnect peripheral %s err:%s \n", [[peripheral.identifier UUIDString] UTF8String], [error.description UTF8String]);
}


- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self processDisconnectPeripheral:peripheral];
    printf("fail connect peripheral %s err:%s \n", [[peripheral.identifier UUIDString] UTF8String], [error.description UTF8String]);

}



#pragma mark - Bluethooth Peripheral

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
//    printf("p:%s discover services err:%s\n",[[peripheral.identifier UUIDString] UTF8String],[error.description UTF8String]);
    
    for (CBService *service in peripheral.services)
    {
        
        if ([service.UUID isEqual:LED_SERVICE_UUID])
        {
    
            [peripheral discoverCharacteristics:LED_CHAR_UUIDS forService:service];
            
        }
    }
    if (error) {
        printf("p:%s discover services err:%s\n",[[peripheral.identifier UUIDString] UTF8String],[error.description UTF8String]);
        [self processDisconnectPeripheral:peripheral];
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
        
//        printf("p:%s,s:%s discover characteristics\n",[[peripheral.identifier UUIDString] UTF8String],[service.UUID.data.description  UTF8String]);
    }
    else
    {
        printf("p:%s,s:%s discover characteristics err:%s \n", [[peripheral.identifier UUIDString] UTF8String],[service.UUID.data.description  UTF8String],[error.description UTF8String]);
        [self processDisconnectPeripheral:peripheral];
    }
    
   
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        printf("!!!p:%s c:%s write err:%s!!!\n",[[peripheral.identifier UUIDString] UTF8String],[characteristic.UUID.data.description UTF8String],[[error description] UTF8String] );
        
    }
    
}

- (void)confirmPeripheral:(CBPeripheral *)peripheral forCharateristic:(CBCharacteristic *)characteristic
{
    if (characteristic.value.length != 6) {
        return ;
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
    
//    NSLog(@"%@",recvAddrData);
//    printf("recv addr string %s \n",[recvAddrString UTF8String]);
    
    NSUInteger i = 0;
    for (;i < _dataModel.LEDs.count; i++)
    {
        LEDItem *aLED = _dataModel.LEDs[i];
        if ([aLED.blueAddr isEqualToString:recvAddrString])
        {
            aLED.bluePeripheral = peripheral;
            aLED.characteristics = [[peripheral.services firstObject] characteristics];
            [_LEDCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
            //写验证消息，验证消息为蓝牙地址后3个字节
            [aLED writeConfirmation:[recvAddrData subdataWithRange:NSMakeRange(3, 3)]];
            aLED.identifier = peripheral.identifier;
            //读取led的亮度等信息
            for (CBCharacteristic *charac in aLED.characteristics)
            {
                if ([charac.UUID isEqual:LED_CHAR_ON_OFF_UUID] &&
                    charac.properties & CBCharacteristicPropertyRead)
                {
                    [peripheral readValueForCharacteristic:charac];
                }
                if ([charac.UUID isEqual:LED_CHAR_LIGHT_UUID] &&
                    charac.properties & CBCharacteristicPropertyRead)
                {
                    [peripheral readValueForCharacteristic:charac];
                }
                if ([charac.UUID isEqual:LED_CHAR_TEMP_UUID] &&
                    charac.properties & CBCharacteristicPropertyRead)
                {
                    [peripheral readValueForCharacteristic:charac];
                }
               
                
            }
            break;
        }
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    
    if (!error)
    {
       
//        printf("p:%s c:%s read value:%s\n",
//               [[peripheral.identifier UUIDString] UTF8String],
//               [characteristic.UUID.data.description UTF8String],
//               [[characteristic.value description] UTF8String]);
        //先验证led
        if ([characteristic.UUID isEqual:LED_CHAR_ID_UUID]) {
            [self confirmPeripheral:peripheral forCharateristic:characteristic];
        }
        
        //读出onOff信息
        if ([characteristic.UUID isEqual:LED_CHAR_ON_OFF_UUID]) {
            for (LEDItem *aLED in _dataModel.LEDs)
            {
                if (aLED.bluePeripheral == peripheral)
                {
                    BOOL value;
                    [characteristic.value getBytes:&value length:1];
                    aLED.onOff = value ;
                    break;
                }
            }

        }
        //读出light信息
        if ([characteristic.UUID isEqual:LED_CHAR_LIGHT_UUID]) {
            for (LEDItem *aLED in _dataModel.LEDs)
            {
                if (aLED.bluePeripheral == peripheral)
                {
                    unsigned char value;
                    [characteristic.value getBytes:&value length:1];
                    aLED.currentLight = value ;
                    break;
                }
            }
            
        }
        //读出temp信息
        if ([characteristic.UUID isEqual:LED_CHAR_TEMP_UUID]) {
            for (LEDItem *aLED in _dataModel.LEDs)
            {
                if (aLED.bluePeripheral == peripheral)
                {
                    unsigned char value;
                    [characteristic.value getBytes:&value length:1];
                    aLED.currentTemp = value;
                    break;
                }
            }
            
        }


    }
    else
    {
        
        printf("!!!p:%s c:%s read err:%s!!!\n",[[peripheral.identifier UUIDString] UTF8String],[characteristic.UUID.data.description UTF8String],[[error description] UTF8String] );

    }
    [_discoverPeripherals removeObject:peripheral];
    
}

- (UIImageView *)snapshortImageView
{
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, YES, 0);
    [self.view drawViewHierarchyInRect:self.view.frame afterScreenUpdates:NO];
    UIImage *im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    im = [UIImageEffects imageByApplyingLightEffectToImage:im];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:im];
    return iv;
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

        
        UIImageView *snapView = [self snapshortImageView];
        [editVC.view addSubview:snapView];
        [editVC.view sendSubviewToBack:snapView];
        
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
