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

@interface LEDViewController ()


@property (nonatomic,strong) NSMutableArray *selectLEDs;


@property (weak, nonatomic) IBOutlet UICollectionView *LEDCollectionView;
@property (weak, nonatomic) IBOutlet UIView *LEDControlView;
@property (weak, nonatomic) IBOutlet UILabel *lightLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UISlider *lightSlider;
@property (weak, nonatomic) IBOutlet UISlider *tempSlider;


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
    self.LEDCollectionView.allowsMultipleSelection = YES;
    
   
    self.lightSlider.enabled = NO;
    self.tempSlider.enabled = NO;

}

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
        
        self.editLED = ((TabBarViewController *)(self.tabBarController)).allLEDs[index.row];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [((TabBarViewController *)(self.tabBarController)).allLEDs removeObject:self.editLED];
            [self.LEDCollectionView reloadData];
            break;
        case 1:
            [self performSegueWithIdentifier:@"toLEDEdit" sender:self];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((TabBarViewController *)(self.tabBarController)).allLEDs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LEDCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    LEDItem *aLED = ((TabBarViewController *)(self.tabBarController)).allLEDs[indexPath.row];
    cell.imageView.image = aLED.image;
    cell.nameLabel.text = aLED.name;
    cell.selectedImageView.image = aLED.selectedImage;
    
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
    
    LEDItem *aLED = ((TabBarViewController *)(self.tabBarController)).allLEDs[indexPath.row];
    
    
    if([self.selectLEDs containsObject:aLED])
    {
        aLED.selectedImage = nil;
        [self.selectLEDs removeObject:aLED];
        
        
    }
    else
    {
        aLED.selectedImage = [UIImage imageNamed:@"LED1.png"];
        [self.selectLEDs addObject:aLED];
        
        [self.lightSlider setValue:aLED.currentLight animated:YES];
        [self.tempSlider setValue:aLED.currentTemp animated:YES];
        self.lightLabel.text = [NSString stringWithFormat:@"%d%%",aLED.currentLight];
        self.tempLabel.text = [NSString stringWithFormat:@"%d%%",aLED.currentTemp];
    }
    
    if (self.selectLEDs.count > 0) {
        self.lightSlider.enabled = YES;
        self.tempSlider.enabled = YES;
    }
    else
    {
        self.lightSlider.enabled = NO;
        self.tempSlider.enabled = NO;
    }
    
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
}




- (void) loadInit
{
    
    for(int i = 0; i < 8; i++)
    {
        LEDItem *aLED = [[LEDItem alloc] init];
        aLED.image = [UIImage imageNamed:@"LED0.png"];
        aLED.name = [NSString stringWithFormat:@"LED %d", i];
        
        
        [((TabBarViewController *)(self.tabBarController)).allLEDs addObject:aLED];
    }
   
}



- (IBAction)lightChange:(id)sender {
    UISlider *slider = sender;
    self.lightLabel.text = [NSString stringWithFormat:@"%d%%",(int)slider.value];
 
    for (LEDItem *aLED in self.selectLEDs) {
        aLED.currentLight = (int)slider.value;
    }
}

- (IBAction)tempChange:(id)sender {
    UISlider *slider = sender;
    self.tempLabel.text = [NSString stringWithFormat:@"%d%%",(int)slider.value];
    
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
