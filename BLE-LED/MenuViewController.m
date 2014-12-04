//
//  MenuViewController.m
//  BLE-LED
//
//  Created by lxl on 14-11-25.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuHeader.h"
#import "MenuCell.h"
#import "UIImageEffects.h"

NSString * const MenuCellReuseIdentifier = @"Drawer Cell";
NSString * const DrawerHeaderReuseIdentifier = @"Drawer Header";

typedef NS_ENUM(NSUInteger, MenuViewControllerTableViewSectionType) {
    MenuViewControllerTableViewSectionTypeControl,
    MenuViewControllerTableViewSectionTypeAbout,
    MenuViewControllerTableViewSectionTypeCount
};

@interface MenuViewController ()

@property (nonatomic, strong) NSDictionary *paneViewControllerTitles;
@property (nonatomic, strong) NSDictionary *paneViewControllerIdentifiers;

@property (nonatomic, strong) NSDictionary *sectionTitles;
@property (nonatomic, strong) NSArray *tableViewSectionBreaks;

@property (nonatomic, strong) UIBarButtonItem *paneStateBarButtonItem;


@property (nonatomic, strong) UIImage *revealLeftImage;
@property (nonatomic, strong) UIImage *backgroundImage;

@end

@implementation MenuViewController

#pragma mark - NSObject

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)loadView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[MenuCell class] forCellReuseIdentifier:MenuCellReuseIdentifier];
    [self.tableView registerClass:[MenuHeader class] forHeaderFooterViewReuseIdentifier:DrawerHeaderReuseIdentifier];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.25];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MSMenuViewController

- (void)initialize
{
    self.paneViewControllerType = NSUIntegerMax;
    self.paneViewControllerTitles = @{
                                      @(PaneViewControllerTypeLED) : @"LED",
                                      @(PaneViewControllerTypeGroup) : @"Group",
                                      @(PaneViewControllerTypeScene) : @"Scene",
                                      @(PaneViewControllerTypeGreeble) : @"Greeble Ltd.",
                                      };

    self.paneViewControllerIdentifiers = @{
                                           @(PaneViewControllerTypeLED) : @"LEDList",
                                           @(PaneViewControllerTypeGroup) : @"GroupList",
                                           @(PaneViewControllerTypeScene) : @"SceneList",
                                           @(PaneViewControllerTypeGreeble) : @"Greeble",
                                           };
    self.sectionTitles = @{
                           @(MenuViewControllerTableViewSectionTypeControl) : @"Control",
                           @(MenuViewControllerTableViewSectionTypeAbout) : @"About",
                           };
    self.tableViewSectionBreaks = @[
                                    @(PaneViewControllerTypeGreeble),
                                    @(PaneViewControllerTypeCount)
                                    ];
}

- (PaneViewControllerType)paneViewControllerTypeForIndexPath:(NSIndexPath *)indexPath
{
    PaneViewControllerType paneViewControllerType;
    if (indexPath.section == 0) {
        paneViewControllerType = indexPath.row;
    } else {
        paneViewControllerType = ([self.tableViewSectionBreaks[(indexPath.section - 1)] integerValue] + indexPath.row);
    }
    NSAssert(paneViewControllerType < PaneViewControllerTypeCount, @"Invalid Index Path");
    return paneViewControllerType;
}

- (UIImage *)revealLeftImage
{
    if (!_revealLeftImage) {
        CGSize sz = CGSizeMake(20, 24);
        UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
        UIBezierPath *p = [UIBezierPath bezierPath];
        [p setLineWidth:2];
        
        //绘制四条水平间隔横杠
        int n = 3;
        for (int i = 0; i < n; i++) {
            [p moveToPoint:CGPointMake(0, sz.height / (n + 1) * (i + 1))];
            [p addLineToPoint:CGPointMake(sz.width, sz.height / (n + 1) * (i + 1))];
            [p stroke];
        }
        self.revealLeftImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _revealLeftImage;
}

- (UIImage *)backgroundImage
{
    if(!_backgroundImage) {
        UIImage *im = [UIImage imageNamed:@"background.png"];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.1)
        {
            // There was a bug in iOS versions 7.0.x which caused vImage buffers
            // created using vImageBuffer_InitWithCGImage to be initialized with data
            // that had the reverse channel ordering (RGBA) if BOTH of the following
            // conditions were met:
            //      1) The vImage_CGImageFormat structure passed to
            //         vImageBuffer_InitWithCGImage was configured with
            //         (kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little)
            //         for the bitmapInfo member.  That is, if you wanted a BGRA
            //         vImage buffer.
            //      2) The CGImage object passed to vImageBuffer_InitWithCGImage
            //         was loaded from an asset catalog.
            //
            // To reiterate, this bug only affected images loaded from asset
            // catalogs.
            //
            // The workaround is to setup a bitmap context, draw the image, and
            // capture the contents of the bitmap context in a new image.
            
            UIGraphicsBeginImageContextWithOptions(im.size, NO, im.scale);
            [im drawAtPoint:CGPointZero];
            im = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        im = [UIImageEffects imageByApplyingLightEffectToImage:im];
        _backgroundImage = im;
    }
    return _backgroundImage;
}

- (void)transitionToViewController:(PaneViewControllerType)paneViewControllerType
{
    // Close pane if already displaying the pane view controller
    if (paneViewControllerType == self.paneViewControllerType) {
        [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateClosed animated:YES allowUserInterruption:YES completion:nil];
        return;
    }
    
    BOOL animateTransition = self.dynamicsDrawerViewController.paneViewController != nil;
    
    UIViewController *paneViewController = [self.storyboard instantiateViewControllerWithIdentifier:self.paneViewControllerIdentifiers[@(paneViewControllerType)]];

    paneViewController.navigationItem.title = self.paneViewControllerTitles[@(paneViewControllerType)];
    
    //背景图片
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:paneViewController.view.frame];
    bgImageView.image = self.backgroundImage;
    [paneViewController.view addSubview:bgImageView];
    [paneViewController.view sendSubviewToBack:bgImageView];
    

    //设置左边的navigation图标
    UIBarButtonItem *paneRevealLeftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:self.revealLeftImage style:UIBarButtonItemStyleBordered target:self action:@selector(dynamicsDrawerRevealLeftBarButtonItemTapped:)];
    paneViewController.navigationItem.leftBarButtonItem = paneRevealLeftBarButtonItem;
    
    
    UINavigationController *paneNavigationViewController = [[UINavigationController alloc] initWithRootViewController:paneViewController];
    //navigationbar为蓝色
    paneNavigationViewController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.6 blue:1 alpha:0.8];
    paneNavigationViewController.navigationBar.tintColor = [UIColor whiteColor];
    paneNavigationViewController.navigationBar.translucent = YES;
    [self.dynamicsDrawerViewController setPaneViewController:paneNavigationViewController animated:animateTransition completion:nil];
    
    self.paneViewControllerType = paneViewControllerType;
}

- (void)dynamicsDrawerRevealLeftBarButtonItemTapped:(id)sender
{
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionLeft animated:YES allowUserInterruption:YES completion:nil];
}

- (void)dynamicsDrawerRevealRightBarButtonItemTapped:(id)sender
{
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionRight animated:YES allowUserInterruption:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return MenuViewControllerTableViewSectionTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.tableViewSectionBreaks[section] integerValue];
    } else {
        return ([self.tableViewSectionBreaks[section] integerValue] - [self.tableViewSectionBreaks[(section - 1)] integerValue]);
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:DrawerHeaderReuseIdentifier];
    headerView.textLabel.text = [self.sectionTitles[@(section)] uppercaseString];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FLT_EPSILON;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MenuCellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.paneViewControllerTitles[@([self paneViewControllerTypeForIndexPath:indexPath])];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaneViewControllerType paneViewControllerType = [self paneViewControllerTypeForIndexPath:indexPath];
    [self transitionToViewController:paneViewControllerType];
    
    // Prevent visual display bug with cell dividers
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.tableView reloadData];
    });
}


@end
