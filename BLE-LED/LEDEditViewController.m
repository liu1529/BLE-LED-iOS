//
//  LEDEditViewController.m
//  BLE-LED
//
//  Created by xlliu on 14-8-4.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "LEDEditViewController.h"
#import "ImageCollectionCell.h"
#import "LEDItem.h"
#import "LEDAddViewController.h"


@interface LEDEditViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (nonatomic) IBOutlet UIImageView *LEDImageView;
@property (weak, nonatomic) IBOutlet UITextField *LEDNameLabel;
- (IBAction)hideKeyboard:(id)sender;


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
    
  

}

- (void)viewWillAppear:(BOOL)animated
{
    //set collectionview delegate
    self.imageCollectionView.dataSource = self;
    self.imageCollectionView.delegate = self;
    
    //init allImages array
    self.allImages = [NSMutableArray new];
    for (int i = 0; i < 3; i++) {
        [self.allImages
         addObject:[UIImage imageNamed:
                    [NSString stringWithFormat:@"LED%d.png",i]]];
    }
    
    //navi
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:
                                   UIBarButtonSystemItemDone
                                   target:self
                                   action:@selector(doneAction:)];
    UIBarButtonItem *trashButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:
                                    UIBarButtonSystemItemTrash
                                    target:self action:@selector(trashAction:)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:
                                     UIBarButtonSystemItemCancel
                                     target:self
                                     action:@selector(cancelAction:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    
 
    //from list view
    if ([self.presentingViewController isKindOfClass:[UITabBarController class]])
    {
        //set listVIewCotroller
        UITabBarController *tabBarController = (UITabBarController *)self.presentingViewController;
        UINavigationController *naviController = (UINavigationController *)tabBarController.selectedViewController;
        self.listViewController = (LEDViewController *)naviController.topViewController;
        
        //set the led's image and name
        self.LEDImageView.image = self.listViewController.editLED.image;
        self.LEDNameLabel.text = self.listViewController.editLED.name;
        
        self.navigationItem.rightBarButtonItems = @[doneButton,trashButton];
        
       
        
    }
    //from add view
    else if([self.presentingViewController isKindOfClass:[UINavigationController class]])
    {
         UINavigationController *naviController = (UINavigationController *)self.presentingViewController;
        self.addViewController = (LEDAddViewController *)naviController.topViewController;
        
        self.LEDImageView.image = self.allImages[0];
        
        self.navigationItem.rightBarButtonItem = doneButton;
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



- (void) trashAction:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void)
        {
            self.listViewController.editLED.image = nil;
            self.listViewController.editLED.name = nil;
            [self.listViewController unWindToList:sender];
        }];
}

- (void)cancelAction:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneAction:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void)
        {
            self.listViewController.editLED.image = self.LEDImageView.image;
            self.listViewController.editLED.name = self.LEDNameLabel.text;
            [self.listViewController unWindToList:sender];
            
            self.addViewController.addLED.image = self.LEDImageView.image;
            self.addViewController.addLED.name = self.LEDNameLabel.text;
            [self.addViewController unWindToAdd:sender];

        }];
    
    

}
- (IBAction)hideKeyboard:(id)sender {
    [self.LEDNameLabel resignFirstResponder];
}
@end
