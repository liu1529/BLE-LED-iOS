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

@interface GrpEditViewController () <UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *ledNumsLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *expandBtn;
@property (weak, nonatomic) IBOutlet UIImageView *expandImageView;
@property (weak, nonatomic) IBOutlet UISlider *lightSlider;
@property (weak, nonatomic) IBOutlet UISlider *tempSlider;

@property (nonatomic) BOOL isExpand;

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
    _image.image = _editGrp.image;
    _nameTextField.text = _editGrp.name;
    _ledNumsLabel.text = [NSString stringWithFormat:@"%d",(int)_editGrp.LEDs.count];
    
    _isExpand = NO;
    _expandImageView.transform = CGAffineTransformMakeRotation(M_PI);
    
    [_lightSlider setMinimumValue:LED_LIGHT_MIN];
    [_lightSlider setMaximumValue:LED_LIGHT_MAX];
    [_tempSlider setMinimumValue:LED_TEMP_MIN];
    [_tempSlider setMaximumValue:LED_TEMP_MAX];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:_isAdd animated:YES];
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
    return _isExpand ? 1 : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _isExpand ? [DataModel sharedDataModel].LEDs.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GrpCollectionCell *cell = [collectionView
                               dequeueReusableCellWithReuseIdentifier:@"GrpCollectionCell" forIndexPath:indexPath];
    
    LEDItem *aLED = [DataModel sharedDataModel].LEDs[indexPath.row];
    
    cell.imageView.image = aLED.bluePeripheral ? aLED.image : [aLED.image withFilterName: @"CIPhotoEffectMono"];
//    cell.imageView.image = aLED.image;
    cell.nameLabel.text = aLED.name;
    
    //选择后，为灰色背景
    UIView *selectView = [[UIView alloc] initWithFrame:cell.frame];
    selectView.backgroundColor = [UIColor grayColor];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select.png"]];
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    [selectView addSubview:iv];
    
    [selectView addConstraint:
     [NSLayoutConstraint
      constraintWithItem:selectView
      attribute:NSLayoutAttributeBottom
      relatedBy:0
      toItem:iv
      attribute:NSLayoutAttributeBottom
      multiplier:1 constant:0]];
    
    [selectView addConstraint:
     [NSLayoutConstraint
      constraintWithItem:selectView
      attribute:NSLayoutAttributeTrailing
      relatedBy:0
      toItem:iv
      attribute:NSLayoutAttributeTrailing
      multiplier:1 constant:0]];
    
    [iv addConstraint:
     [NSLayoutConstraint
      constraintWithItem:iv
      attribute:NSLayoutAttributeWidth
      relatedBy:0
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:0 constant:20]];
    
    [iv addConstraint:
     [NSLayoutConstraint
      constraintWithItem:iv
      attribute:NSLayoutAttributeHeight
      relatedBy:0
      toItem:nil
      attribute:NSLayoutAttributeNotAnAttribute
      multiplier:0 constant:20]];
    
    
    cell.selectedBackgroundView = selectView;
    
    if ([_editGrp.LEDs containsObject:aLED]) {
        [collectionView
         selectItemAtIndexPath:indexPath
         animated:YES
         scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
    else
    {
        [collectionView
         deselectItemAtIndexPath:indexPath animated:YES];
    }
    if ([_editGrp.LEDs containsObject:aLED])
        [cell setSelected:YES];
    else
        [cell setSelected:NO];

    
    return cell;
}




#pragma mark - UICollectionViewDelegate



- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LEDItem *aLED = [DataModel sharedDataModel].LEDs[indexPath.row];
    [_editGrp addLED:aLED];
    _ledNumsLabel.text = [NSString stringWithFormat:@"%d",(int)(_editGrp.LEDs.count)];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LEDItem *aLED = [DataModel sharedDataModel].LEDs[indexPath.row];
    [_editGrp removeLED:aLED];
    _ledNumsLabel.text = [NSString stringWithFormat:@"%d",(int)(_editGrp.LEDs.count)];
}



#pragma mark - Buttons

- (IBAction)lightChange:(UISlider *)sender
{
    for (LEDItem *aLED in _editGrp.LEDs) {
        aLED.currentLight = sender.value;
    }
}

- (IBAction)tempChange:(UISlider *)sender
{
    for (LEDItem *aLED in _editGrp.LEDs) {
        aLED.currentTemp = sender.value;
    }
}

-(IBAction)expandAction:(UIButton *)sender
{
    _isExpand = !_isExpand;
    _expandImageView.transform = _isExpand ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0);
    
    [_collectionView reloadData];
}

- (IBAction)doneAction:(id)sender
{
    
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
