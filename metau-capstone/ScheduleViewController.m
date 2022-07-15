//
//  ScheduleViewController.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/6/22.
//

#import "ScheduleViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "Schedule.h"
#import "Utilities.h"
#import "ScheduleCell.h"

@interface ScheduleViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *scheduleCollection;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scheduleCollection.dataSource = self;
    self.scheduleCollection.delegate = self;
}

- (void)viewDidLayoutSubviews {
   [super viewDidLayoutSubviews];

    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
}


- (IBAction)didTapLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    Utilities* utility = [[Utilities alloc] init];
    [utility logout: sceneDelegate];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ScheduleCell *cell = [self.scheduleCollection dequeueReusableCellWithReuseIdentifier:@"ScheduleCollectionCell" forIndexPath:indexPath];
    cell.dayNum.text = [NSString stringWithFormat:@"%ld", indexPath.row+1];
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.borderWidth = 1;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 64;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int totalwidth = self.scheduleCollection.bounds.size.width;
    int numberOfCellsPerRow = 4;
    
    int dimensions = (CGFloat)(totalwidth / (numberOfCellsPerRow + 1));
    return CGSizeMake(dimensions, dimensions);
}

@end
