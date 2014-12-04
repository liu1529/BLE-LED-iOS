//
//  GrpEditViewController.m
//  BLE-LED
//
//  Created by xlliu on 14-9-16.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "GrpEditViewController.h"
#import "DataModel.h"
#import "GrpCollectionCell.h"
#import "UIImage+Filter.h"
#import "GrpEditLedsCell.h"
#import "GrpEditLedsHeader.h"
#import "GrpEditOnOffCell.h"
#import "GrpEditOnOffHeader.h"

@interface GrpEditViewController () <UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout,
                                    UIActionSheetDelegate,
                                    GrpEditHeaderDelegate,
                                    GrpEditCellDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *ledNumsLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) BOOL isLedsExpand;
@property (nonatomic) BOOL isOnOffExpand;

@end

@implementation GrpEditViewController

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
    
    
    _collectionView.allowsMultipleSelection = YES;
    
    self.imageView.image = _editGrp.image;
    self.imageView.layer.cornerRadius = 15;
    self.imageView.layer.masksToBounds = YES;
    
    self.nameTextField.text = _editGrp.name;
    _ledNumsLabel.text = [NSString stringWithFormat:@"%d/%d",
                          (int)_editGrp.LEDs.count,
                          (int)[DataModel sharedDataModel].LEDs.count];
    
    _isOnOffExpand = YES;
    _isLedsExpand = NO;
    
    
    //注册cell和header
    [self.collectionView registerNib:[UINib nibWithNibName:@"GrpEditLedsHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LedsHeader"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GrpEditOnOffHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"OnOffHeader"];
    [self.collectionView registerClass:[GrpEditLedsCell class] forCellWithReuseIdentifier:@"LedsCell"];
    [self.collectionView registerClass:[GrpEditOnOffCell class] forCellWithReuseIdentifier:@"OnOffCell"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:_isAdd animated:YES];
    self.navigationController.toolbar.translucent = YES;
    self.navigationController.toolbar.barTintColor = [UIColor colorWithRed:0 green:0.5 blue:1 alpha:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)hideKeyboard:(id)sender
{
    [_nameTextField resignFirstResponder];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _isOnOffExpand ? 2 : 0;
    } else {
        return _isLedsExpand ? [DataModel sharedDataModel].LEDs.count : 0;
    }
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        GrpEditOnOffCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OnOffCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.label.text = @"Lumen:";
            [cell.slider setMaximumValue:LED_LIGHT_MAX];
            [cell.slider setMinimumValue:LED_LIGHT_MIN];
        } else {
            cell.label.text = @"CCT:";
            [cell.slider setMaximumValue:LED_TEMP_MAX];
            [cell.slider setMinimumValue:LED_TEMP_MIN];
        }
        cell.delegate = self;
        return cell;
        
    } else {
        GrpEditLedsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LedsCell" forIndexPath:indexPath];
        LEDItem *aLED = [DataModel sharedDataModel].LEDs[indexPath.row];
        cell.imageView.image = aLED.bluePeripheral ? aLED.image : [aLED.image withFilterName: @"CIPhotoEffectMono"];
        
        cell.label.text = aLED.name;
        
        if ([_editGrp.LEDs containsObject:aLED]) {
            [collectionView
            selectItemAtIndexPath:indexPath
                 animated:YES
                 scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            cell.selected = YES;
        }
        else
        {
            [collectionView
                 deselectItemAtIndexPath:indexPath animated:YES];
            cell.selected = NO;
        }
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *f = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        return f;
    }
    
    if (indexPath.section == 0) {
        GrpEditOnOffHeader *h = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"OnOffHeader" forIndexPath:indexPath];
        h.section = indexPath.section;
        h.delegate = self;
        h.sw.on = self.isOnOffExpand;
        return h;
    }
    if(indexPath.section == 1) {
        GrpEditLedsHeader *h = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LedsHeader" forIndexPath:indexPath];
        h.section = indexPath.section;
        h.delegate = self;
        h.imageView.transform = _isLedsExpand ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0);

        return h;
       
    }
    return nil;
}


#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LEDItem *aLED = [DataModel sharedDataModel].LEDs[indexPath.row];
    [_editGrp addLED:aLED];
    _ledNumsLabel.text = [NSString stringWithFormat:@"%d/%d",
                          (int)(_editGrp.LEDs.count),
                          (int)[DataModel sharedDataModel].LEDs.count];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    LEDItem *aLED = [DataModel sharedDataModel].LEDs[indexPath.row];
    [_editGrp removeLED:aLED];
    _ledNumsLabel.text = [NSString stringWithFormat:@"%d/%d",
                          (int)(_editGrp.LEDs.count),
                          (int)[DataModel sharedDataModel].LEDs.count];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = collectionView.frame.size.width - 16;
    
    if (indexPath.section == 0) {
        return CGSizeMake(width, 50);
    }
    //每行放3个led灯
    CGFloat imageWidth = (width - 2 * ((UICollectionViewFlowLayout *)collectionViewLayout).minimumInteritemSpacing) / 3;
    return CGSizeMake(imageWidth, imageWidth);
    
}

#pragma mark - GrpEditHeaderDelegate & GrpEditCellDelegate

- (void)grpEditHeader:(UICollectionReusableView *)h inSection:(NSUInteger)section valueChangeInView:(UIView *)view
{
    if (section == 0) {
//        NSInteger numOfItems = [self.collectionView numberOfItemsInSection:section];
//        for (int i = 0; i < numOfItems; i++) {
//            NSIndexPath *p = [NSIndexPath indexPathForItem:i inSection:section];
//            GrpEditOnOffCell *cell = (GrpEditOnOffCell *)[self.collectionView cellForItemAtIndexPath:p];
//            cell.slider.enabled = ((UISwitch *)view).on;
//        }
        self.isOnOffExpand = ((UISwitch *)view).on;
        for (LEDItem *led in _editGrp.LEDs) {
            led.onOff = ((UISwitch *)view).on;
        }
        
    }
    else if (section == 1) {
        self.isLedsExpand = !self.isLedsExpand;
    }
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:section]];

}

- (void)grpEditCell:(UICollectionViewCell *)cell valueChangeInView:(UIView *)view
{
    NSIndexPath *p = [self.collectionView indexPathForCell:cell];
    for (LEDItem *led in _editGrp.LEDs) {
        if (p.row == 0) {
            led.currentLight = ((GrpEditOnOffCell *)cell).slider.value;
        }
        else if (p.row == 1)
        {
            led.currentTemp = ((GrpEditOnOffCell *)cell).slider.value;

        }
    }
    
}


#pragma mark - Buttons


- (IBAction)doneAction:(id)sender
{
    _editGrp.name = self.nameTextField.text;
    if (_completionBlock) {
        _completionBlock(YES);
    }
}

- (IBAction) transhGroup:(id) sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Delete Group"
                                  otherButtonTitles:nil];
    [actionSheet showFromBarButtonItem:sender animated:YES];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[DataModel sharedDataModel] removeGroupFromList:_editGrp];
        if (self.completionBlock) {
            self.completionBlock(YES);
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
