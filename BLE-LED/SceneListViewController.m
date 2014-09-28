//
//  SceneListViewController.m
//  BLE-LED
//
//  Created by xlliu on 14-8-7.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "SceneListViewController.h"
#import "SceneCollectionCell.h"
#import "DataModel.h"
#import "SceneEditViewController.h"


@interface SceneListViewController ()

@property (strong,nonatomic) SceneItem* editScene;

@end

@implementation SceneListViewController
{
    DataModel *_dataModel;
}



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
    self.navigationItem.rightBarButtonItem = [self editButtonItem];
   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setEditing:NO animated:NO];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collectionview

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataModel.scenes.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SceneCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellScene" forIndexPath:indexPath];
    
    if (indexPath.row >= _dataModel.scenes.count) {
        cell.imageView.image = [UIImage imageNamed:@"add_icon.png"];
        cell.label.text = @"Add Scene";
        return cell;
    }
    
    SceneItem *scene = _dataModel.scenes[indexPath.row];
    
    cell.imageView.image = scene.image;
    cell.label.text = scene.name;
    
    
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < _dataModel.scenes.count &&
        !self.isEditing)
    {
        [[DataModel sharedDataModel].scenes[indexPath.row] call];
    }
    else
    {
        [self performSegueWithIdentifier:@"toSceneEdit" sender:indexPath];
    }
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *index = sender;
    
    if (index.row >= _dataModel.scenes.count)
    {
        //add scene
        SceneEditViewController *editVC = segue.destinationViewController;
        editVC.isAdd = YES;
        SceneItem *scene = [SceneItem SceneWithName:@"new scene" Image:[UIImage imageNamed:@"scene4.png"]];
        editVC.editScene = scene;
        editVC.isAdd = YES;
       
       
        editVC.completionBlock = ^(BOOL success)
        {
            if (success)
            {
                [_dataModel addScene:scene];
                [self.collectionView reloadData];
                [_dataModel saveData];
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        };

    }
    else
    {
        //edit scene
        SceneEditViewController *editVC = segue.destinationViewController;
        editVC.editScene = _dataModel.scenes[index.row];
        editVC.isAdd = NO;
        
        editVC.completionBlock = ^(BOOL success)
        {
            if (success)
            {
                [self.collectionView reloadData];
                [_dataModel saveData];
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
           
        };

        
    }
    
}



@end
