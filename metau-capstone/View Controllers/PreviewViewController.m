//
//  PreviewViewController.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/26/22.
//

#import "PreviewViewController.h"
#import "SceneDelegate.h"
#import "PreviewCell.h";

@interface PreviewViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *previewCarousel;

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.previewCarousel.dataSource = self;
}

- (IBAction)didPressDone:(UIBarButtonItem *)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    [tabBarController setSelectedIndex:1];
    sceneDelegate.window.rootViewController = tabBarController;
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
    PreviewCell * cell = [self.previewCarousel dequeueReusableCellWithReuseIdentifier:@"PreviewCell" forIndexPath:indexPath];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}


@end
