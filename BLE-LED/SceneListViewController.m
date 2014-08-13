//
//  SceneListViewController.m
//  BLE-LED
//
//  Created by xlliu on 14-8-7.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "SceneListViewController.h"
#import "SceneCollectionCell.h"
#import "TabBarViewController.h"


@interface SceneListViewController ()



@end

@implementation SceneListViewController

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
                                      initWithTitle:@"Del or edit it?"
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:@"Del It"
                                      otherButtonTitles:@"Edit It", nil];
        [actionSheet showInView:self.view];
        
        
        
        NSIndexPath *index = [self.collectionView
                              indexPathForItemAtPoint:
                              [sender locationInView:self.collectionView]];
        
        self.editScene = ((TabBarViewController *)(self.tabBarController)).allScenes[index.row];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [((TabBarViewController *)(self.tabBarController)).allScenes removeObject:self.editScene];
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
    return ((TabBarViewController *)self.tabBarController).allScenes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SceneCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellScene" forIndexPath:indexPath];
    SceneItem *scene = ((TabBarViewController *)self.tabBarController).allScenes[indexPath.row];
    
    
    
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

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   
    if ([sender isKindOfClass:[UIBarButtonItem class]])
    {
        if (self.addScene == nil)
        {
            self.addScene = [SceneItem new];
            self.addScene.image = [UIImage imageNamed:@"scene4.png"];
            self.addScene.LEDs = [NSMutableArray new];
            self.addScene.lights = [NSMutableArray new];
            self.addScene.temps = [NSMutableArray new];
        }
        

    }
    else if ([sender isKindOfClass:[UIActionSheet class]])
    {
       
        
    }
    
}


- (IBAction)unWindToHere: (id)sender
{
    if (self.addScene.LEDs.count > 0) {
        [((TabBarViewController *)self.tabBarController).allScenes addObject:self.addScene];
        [self.collectionView reloadData];
    }
    self.addScene = nil;
    self.editScene = nil;
}


@end
