//
//  LEDEditViewController.m
//  BLE-LED
//
//  Created by xlliu on 14-8-4.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "LEDEditViewController.h"
#import "ImageCollectionCell.h"
#import "TabBarViewController.h"
#import "LEDAddViewController.h"


@interface LEDEditViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (nonatomic) IBOutlet UIImageView *LEDImageView;
@property (weak, nonatomic) IBOutlet UITextField *LEDNameLabel;

- (IBAction)hideKeyboard:(id)sender;
- (IBAction)doneEdit:(id)sender;
- (IBAction)cancelEdit:(id)sender;


@property (weak,nonatomic) LEDViewController *listViewController;
@property (weak,nonatomic) LEDAddViewController *addViewController;
@property (strong,nonatomic) NSMutableArray *allImages;


@end

@implementation LEDEditViewController

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
    
    //set collectionview delegate
    self.imageCollectionView.dataSource = self;
    self.imageCollectionView.delegate = self;
    
    //init allImages array
    self.allImages = [DataModel sharedDataModel].imageDic[@"LEDImages"];
    
    self.LEDImageView.image = self.editLED.image;
    self.LEDNameLabel.text = self.editLED.name;
    
    if (!_isAdd)
    {
        UIBarButtonItem *fixibleBarItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                           target:self
                                           action:nil];
        
        UIBarButtonItem *trashBarItem = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                         target:self
                                         action:@selector(transhLED)];
        [self setToolbarItems:@[
                                fixibleBarItem,
                                trashBarItem,
                                fixibleBarItem]];
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
    else
    {
         [self.navigationController setToolbarHidden:YES animated:YES];
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
    return self.allImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellImage" forIndexPath:indexPath];
    
    cell.imageView.image = self.allImages[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.LEDImageView.image = self.allImages[indexPath.row];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



- (IBAction)hideKeyboard:(id)sender {
    [self.LEDNameLabel resignFirstResponder];
}

- (IBAction)cancelEdit:(id)sender
{
    if (self.completionBlock) {
        self.completionBlock(NO);
    }
}

- (IBAction)doneEdit:(id)sender {

   
    self.editLED.image = self.LEDImageView.image;
    self.editLED.name = self.LEDNameLabel.text;

    if (self.completionBlock) {
        self.completionBlock(YES);
    }
    
}

- (void) transhLED
{
    [[DataModel sharedDataModel] removeLEDFromList:self.editLED];
    if (self.completionBlock) {
        self.completionBlock(YES);
    }
}

@end
