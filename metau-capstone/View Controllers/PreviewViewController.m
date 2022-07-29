//
//  PreviewViewController.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/26/22.
//

#import "PreviewViewController.h"
#import "SceneDelegate.h"
#import "PreviewCell.h"
#import "APIManager.h"
#import "Parse/Parse.h"
#import "PreviewCard.h"

@interface PreviewViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *previewCarousel;
@property (weak, nonatomic) IBOutlet UITextField *frontTextField;

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.previewCarousel.dataSource = self;
    self.previewCarousel.delegate = self;
    self.frontTextField.hidden = YES;
    self.previewCards = [NSMutableArray new];
    
    // Fetch the preview cards by the current user
    PFUser *const user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"PreviewCard"];
    [query whereKey:@"userID" equalTo:user.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"fetched preview cards");
            for (PreviewCard *card in objects) {
                [self.previewCards addObject:card];
            }
            [self.previewCarousel reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)didPressDone:(UIBarButtonItem *)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    [tabBarController setSelectedIndex:1];
    sceneDelegate.window.rootViewController = tabBarController;
    
    // Clear preview flashcards for current user
    PFUser *const user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"PreviewCard"];
    [query whereKey:@"userID" equalTo:user.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            [PFObject deleteAllInBackground:objects block:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    // The array of objects was successfully deleted.
                } else {
                    // There was an error. Check the errors localizedDescription.
                }
            }];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
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
    PreviewCell *cell = [self.previewCarousel dequeueReusableCellWithReuseIdentifier:@"PreviewCell" forIndexPath:indexPath];
    PreviewCard *card = self.previewCards[indexPath.row];
    [cell createCardBothSides:CGRectMake(10, 70, 270, 162) withFront:card.frontText withBack:card.backText];
    // Setting tag for edit button
    cell.editButton.tag = indexPath.row;
    // Add target and action for edit button
    [cell.editButton addTarget:self action:@selector(didTapEdit:) forControlEvents:UIControlEventTouchUpInside];
    // Setting tag for edit button
    cell.selectButton.tag = indexPath.row;
    // Add target and action for edit button
    [cell.selectButton addTarget:self action:@selector(didTapSelect:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)didTapEdit:(UIButton*)sender
{
    NSLog(@"%ld", sender.tag);
}

-(void)didTapSelect:(UIButton*)sender
{
    NSLog(@"%ld", sender.tag);
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.previewCards count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PreviewCell *cell = (PreviewCell *)[self.previewCarousel cellForItemAtIndexPath:indexPath];
    if (!cell.isFlipped) {
        [cell flipAction:cell.front to:cell.back];
        NSLog(@"front to back");
    } else {
        [cell flipAction:cell.back to:cell.front];
        NSLog(@"back to front");
    }
}
@end
