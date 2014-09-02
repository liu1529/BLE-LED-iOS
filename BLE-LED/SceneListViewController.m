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
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GestureRecognizer

- (void) doLongPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:@"Del It"
                                      otherButtonTitles:@"Edit It", nil];
        [actionSheet showInView:self.view];
        
        
        
        NSIndexPath *index = [self.collectionView
                              indexPathForItemAtPoint:
                              [sender locationInView:self.collectionView]];
        
        self.editScene = _dataModel.Scenes[index.row];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [_dataModel removeSceneFromList:self.editScene];
            [self.collectionView reloadData];
            break;
        case 1:
            [self performSegueWithIdentifier:@"toSceneDetail" sender:actionSheet];
            break;
        default:
            break;
    }
}

#pragma mark - Collectionview

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataModel.Scenes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SceneCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellScene" forIndexPath:indexPath];
    SceneItem *scene = _dataModel.Scenes[indexPath.row];
    
    
    
    cell.imageView.image = scene.image;
    cell.label.text = scene.name;
    
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
    SceneItem *scene = [DataModel sharedDataModel].Scenes[indexPath.row];
    [scene call];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   
    if ([sender isKindOfClass:[UIBarButtonItem class]])
    {
        SceneEditViewController *editVC = segue.destinationViewController;
        SceneItem *theNewScene = [SceneItem SceneWithName:@"new scene" Image:[UIImage imageNamed:@"scene4.png"]];
        editVC.editScene = theNewScene;
        editVC.completionBlock = ^(BOOL success)
        {
            if (success)
            {
                [_dataModel addScene:theNewScene];
                [self.collectionView reloadData];
                [_dataModel saveData];
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        };

    }
    else if ([sender isKindOfClass:[UIActionSheet class]])
    {
        SceneEditViewController *editVC = segue.destinationViewController;
        editVC.editScene = self.editScene;
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
