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
#import "Flashcard.h"

@interface PreviewViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *previewCarousel;
@property (weak, nonatomic) IBOutlet UITextField *frontTextField;
@property (weak, nonatomic) IBOutlet UITextField *backTextField;
@property (nonatomic) NSIndexPath *currentCellPath;

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.previewCarousel.dataSource = self;
    self.previewCarousel.delegate = self;
    self.frontTextField.hidden = YES;
    self.backTextField.hidden = YES;
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
    
    [self.frontTextField addTarget:self action:@selector(frontTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.backTextField addTarget:self action:@selector(backTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (IBAction)didPressDone:(UIBarButtonItem *)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    [tabBarController setSelectedIndex:1];
    sceneDelegate.window.rootViewController = tabBarController;
    
    // Create flashcards
    for (PreviewCard *card in self.previewCards) {
        if (card.isSelected) {
            [Flashcard createCard:card.frontText withBack:card.backText withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if (!error) {
                    NSLog(@"card created!");
                }
                else {
                    NSLog(@"nooo cry %@", error.localizedDescription);
                }
            }];
        }
    }
    
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
- (void)frontTextFieldDidChange: (UIButton*)sender {
    self.editCardIsFlipped = NO;
    PreviewCard *card = self.previewCards[self.currentCellPath.row];
    card.frontText = self.frontTextField.text;
    [self.previewCarousel reloadItemsAtIndexPaths:@[self.currentCellPath]];
}

- (void)backTextFieldDidChange: (UIButton*)sender {
    self.editCardIsFlipped = YES;
    PreviewCard *card = self.previewCards[self.currentCellPath.row];
    card.backText = self.backTextField.text;
    [self.previewCarousel reloadItemsAtIndexPaths:@[self.currentCellPath]];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PreviewCell *cell = [self.previewCarousel dequeueReusableCellWithReuseIdentifier:@"PreviewCell" forIndexPath:indexPath];
    PreviewCard *card = self.previewCards[indexPath.row];
    [cell createCardBothSides:CGRectMake(10, 70, 270, 162) withFront:card.frontText withBack:card.backText isFlipped:self.editCardIsFlipped];
    [self setActionForButton:cell.editButton withTag:indexPath.row withAction:@selector(didTapEdit:)];
    [self setActionForButton:cell.selectButton withTag:indexPath.row withAction:@selector(didTapSelect:)];
    if (card.isSelected) {
        [cell.selectButton setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"] forState:UIControlStateSelected];
        [cell.selectButton setSelected:YES];
    }
    else {
        [cell.selectButton setImage: [UIImage systemImageNamed:@"circle"] forState:UIControlStateNormal];
        [cell.selectButton setSelected:NO];
    }
    return cell;
}

- (void)setActionForButton: (UIButton *)button withTag: (NSInteger)tag withAction:(SEL) selector {
    button.tag = tag;
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTapEdit:(UIButton*)sender {
    PreviewCard *card = self.previewCards[sender.tag];
    [self showTextField:self.frontTextField withText:card.frontText];
    [self showTextField:self.backTextField withText:card.backText];
    self.currentCellPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
}

- (void)showTextField: (UITextField *) textField withText: (NSString *) text {
    textField.text = text;
    textField.hidden = NO;
}

- (void)didTapSelect:(UIButton*)sender {
    PreviewCard *card = self.previewCards[sender.tag];
    card.isSelected = !card.isSelected;
    if ([sender isSelected]) {
        [sender setImage: [UIImage systemImageNamed:@"circle"] forState:UIControlStateNormal];
        [sender setSelected:NO];
    } else {
       [sender setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"] forState:UIControlStateSelected];
       [sender setSelected:YES];
    }
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.previewCards count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PreviewCell *cell = (PreviewCell *)[self.previewCarousel cellForItemAtIndexPath:indexPath];
    if (!cell.isFlipped) {
        [cell flipAction:cell.front to:cell.back];
        cell.isFlipped = !cell.isFlipped;
        NSLog(@"front to back");
    } else {
        [cell flipAction:cell.back to:cell.front];
        cell.isFlipped = !cell.isFlipped;
        NSLog(@"back to front");
    }
}
@end
