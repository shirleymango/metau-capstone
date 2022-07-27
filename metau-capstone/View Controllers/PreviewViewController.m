//
//  PreviewViewController.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/26/22.
//

#import "PreviewViewController.h"
#import "SceneDelegate.h"
#import "PreviewCell.h"

@interface PreviewViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *previewCarousel;
@property (nonatomic, strong) CALayer *front;
@property (nonatomic, strong) CALayer *back;
@property (nonatomic, strong) CATextLayer *frontText;
@property (nonatomic, strong) CATextLayer *backText;

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

- (void) createCardBothSides: (CGRect) frame {
    // BACK SIDE
    self.back = [[CALayer alloc] init];
    self.backText = [[CATextLayer alloc] init];
    [self createCardOneSide:self.back atFrame:frame withText:self.backText withBackgroundColor:[UIColor blackColor] withTextColor:[UIColor whiteColor]];
    // FRONT SIDE
    self.front = [[CALayer alloc] init];
    self.frontText = [[CATextLayer alloc] init];
    [self createCardOneSide:self.front atFrame:frame withText:self.frontText withBackgroundColor:[UIColor whiteColor] withTextColor:[UIColor blackColor]];
}

- (void) createCardOneSide: (CALayer *)side atFrame: (CGRect) frame withText: (CATextLayer *) text withBackgroundColor: (UIColor *) bgColor withTextColor: (UIColor *) textColor {
    side.frame = frame;
    side.backgroundColor = [bgColor CGColor];
    side.borderColor = [[UIColor blackColor] CGColor];
    side.borderWidth = 2;
    [text setFont:@"Helvetica-Bold"];
    [text setFontSize:20];
    [text setAlignmentMode:kCAAlignmentCenter];
    text.wrapped = YES;
    [text setFrame:frame];
    [text setForegroundColor:[textColor CGColor]];
    [side addSublayer:text];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PreviewCell * cell = [self.previewCarousel dequeueReusableCellWithReuseIdentifier:@"PreviewCell" forIndexPath:indexPath];
    [self createCardBothSides:cell.bounds];
    [self.frontText setString:@"front :)"];
    [self.backText setString:@"back"];
    [cell.layer addSublayer:self.back];
    [cell.layer addSublayer:self.front];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}


@end
