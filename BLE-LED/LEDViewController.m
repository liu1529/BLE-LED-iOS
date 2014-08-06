//
//  LEDViewController.m
//  BLE-LED
//
//  Created by xlliu on 14-8-4.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "LEDViewController.h"
#import "LEDItem.h"
#import "LEDCollectionCell.h"
#import "LEDEditViewController.h"

@interface LEDViewController ()

@property (nonatomic,strong) NSMutableArray *allLEDs;
@property (nonatomic,strong) NSMutableArray *selectLEDs;
@property (nonatomic) CGRect LEDCollectionViewFrame;

@property (weak, nonatomic) IBOutlet UICollectionView *LEDCollectionView;
@property (weak, nonatomic) IBOutlet UIView *LEDControlView;
@property (weak, nonatomic) IBOutlet UILabel *lightLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;


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
    self.allLEDs = [[NSMutableArray alloc] init];
    self.selectLEDs = [[NSMutableArray alloc] init];
//    [self loadInit];

    self.LEDCollectionView.dataSource = self;
    self.LEDCollectionView.delegate = self;
    self.LEDCollectionView.allowsSelection = YES;
    self.LEDCollectionView.allowsMultipleSelection = YES;
    
   

}

- (void) doLongPress:(UILongPressGestureRecognizer *)sender
{
    [self performSegueWithIdentifier:@"toLEDEdit" sender:self];
    
    
    NSIndexPath *index = [self.LEDCollectionView
                           indexPathForItemAtPoint:
                            [sender locationInView:self.LEDCollectionView]];
    
    self.editLED = self.allLEDs[index.row];
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
    return self.allLEDs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LEDCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    LEDItem *aLED = self.allLEDs[indexPath.row];
    cell.imageView.image = aLED.image;
    cell.nameLabel.text = aLED.name;
    cell.selectedImageView.image = aLED.selectedImage;
    
    UILongPressGestureRecognizer *longPressGr =
        [[UILongPressGestureRecognizer alloc]
         initWithTarget:self
         action:@selector(doLongPress:)];
    
    [cell addGestureRecognizer:longPressGr];
    
    return cell;
}





- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    LEDItem *aLED = self.allLEDs[indexPath.row];
    
    
    if([self.selectLEDs containsObject:aLED])
    {
        aLED.selectedImage = [UIImage imageNamed:@"LED1.png"];
        [self.selectLEDs removeObject:aLED];
        
        
    }
    else
    {
        aLED.selectedImage = nil;
        [self.selectLEDs addObject:aLED];
       
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
        
        
        [self.allLEDs addObject:aLED];
    }
   
}



- (IBAction)lightChange:(id)sender {
    UISlider *slider = sender;
    self.lightLabel.text = [NSString stringWithFormat:@"%d%%",(int)slider.value];
}

- (IBAction)tempChange:(id)sender {
    UISlider *slider = sender;
    self.tempLabel.text = [NSString stringWithFormat:@"%dK",(int)slider.value];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    if ([segue.identifier isEqualToString:@"toLEDEdit"]) {
//       
//    }
//    else if ([segue.identifier isEqualToString:@"toLEDAdd"])
//    {
//    
//    }
   
   
    
}

- (IBAction)unWindToList:(id)sender
{
    if(self.editLED.image == nil) {
        [self.allLEDs removeObject:self.editLED];
    }
    if (self.addLED.image) {
        [self.allLEDs addObject:self.addLED];
        self.addLED = nil;
    }
    [self.LEDCollectionView reloadData];
}






@end
