//
//  GrpListViewController.m
//  BLE-LED
//
//  Created by xlliu on 14-9-16.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "GrpListViewController.h"
#import "DataModel.h"
#import "GrpCollectionCell.h"
#import "GrpEditViewController.h"

@interface GrpListViewController () <UICollectionViewDataSource>
{
    DataModel *_dataModel;
    UICollectionView *_collectionView;
}

@end

@implementation GrpListViewController

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
    _dataModel = [DataModel sharedDataModel];
    _collectionView = (UICollectionView *)self.view;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataModel.groups.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GrpCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupCell" forIndexPath:indexPath];
    
    if (indexPath.row >= _dataModel.groups.count) {
        cell.imageView.image = [UIImage imageNamed:@"add_icon.png"];
        cell.nameLabel.text = @"Add Group";
        return cell;

    }
    
    GroupItem *grp = _dataModel.groups[indexPath.row];
    
    cell.imageView.image = grp.image;
    cell.nameLabel.text = grp.name;
    
    return cell;
}


#pragma mark - UICollectionViewDelegate




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath *index = [_collectionView indexPathForCell:sender];
    GrpEditViewController *editVC = segue.destinationViewController;
    if (index.row >= _dataModel.groups.count)
    {
        GroupItem *Grp = [GroupItem groupWithName:@"new group" Image:[UIImage imageNamed:@"scene6.png"]];
        editVC.editGrp = Grp;
        editVC.isAdd = YES;
        editVC.completionBlock = ^(BOOL success)
        {
            if (success) {
                [_dataModel addGroup:Grp];
                [_dataModel saveData];
                [_collectionView reloadData];
            }
            [self.navigationController popViewControllerAnimated:YES];
        };
    }
    else
    {
        editVC.editGrp = _dataModel.groups[index.row];
        editVC.isAdd = NO;
        editVC.completionBlock = ^(BOOL success)
        {
            if (success) {
                [_collectionView reloadData];
                [_dataModel saveData];
            }
            [self.navigationController popViewControllerAnimated:YES];
        };

    }
}



@end
