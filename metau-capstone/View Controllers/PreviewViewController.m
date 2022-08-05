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
#import "Flashcard.h"
#import "ImportViewController.h"
#import "PreviewFlashcard.h"
#import "FlashcardView.h"
#import "PreviewManager.h"

@interface PreviewViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *previewCarousel;
@property (weak, nonatomic) IBOutlet UITextField *frontTextField;
@property (weak, nonatomic) IBOutlet UITextField *backTextField;
@property (nonatomic) NSIndexPath *currentCellPath;
@property (weak, nonatomic) IBOutlet UILabel *frontTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *backTextLabel;

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.previewCarousel.dataSource = self;
    self.previewCarousel.delegate = self;
    [self hideEditLabels];
    self.previewCards = [NSMutableArray new];
    
    self.previewCards = [PreviewManager shared].previewFlashcards;
    [self.previewCarousel reloadData];
    
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
    for (PreviewFlashcard *card in self.previewCards) {
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
    PreviewFlashcard *card = self.previewCards[self.currentCellPath.row];
    card.frontText = self.frontTextField.text;
    [self.previewCarousel reloadItemsAtIndexPaths:@[self.currentCellPath]];
}

- (void)backTextFieldDidChange: (UIButton*)sender {
    self.editCardIsFlipped = YES;
    PreviewFlashcard *card = self.previewCards[self.currentCellPath.row];
    card.backText = self.backTextField.text;
    [self.previewCarousel reloadItemsAtIndexPaths:@[self.currentCellPath]];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PreviewCell *cell = [self.previewCarousel dequeueReusableCellWithReuseIdentifier:@"PreviewCell" forIndexPath:indexPath];
    PreviewFlashcard *card = self.previewCards[indexPath.row];
    cell.cardDisplay = [[FlashcardView alloc] initWithText:CGRectMake(10, 70, 270, 162) withFront:card.frontText withBack:card.backText isFlipped:self.editCardIsFlipped];
    [cell addSubview:cell.cardDisplay];
    [self setActionForButton:cell.editButton withTag:indexPath.row withAction:@selector(didTapEdit:)];
    [self setActionForButton:cell.selectButton withTag:indexPath.row withAction:@selector(didTapSelect:)];
    [self toggleSelect:card.isSelected onButton:cell.selectButton];
    return cell;
}

- (void)setActionForButton: (UIButton *)button withTag: (NSInteger)tag withAction:(SEL) selector {
    button.tag = tag;
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTapEdit:(UIButton*)sender {
    PreviewFlashcard *card = self.previewCards[sender.tag];
    self.frontTextLabel.hidden = NO;
    self.backTextLabel.hidden = NO;
    [self showTextField:self.frontTextField withText:card.frontText];
    [self showTextField:self.backTextField withText:card.backText];
    self.currentCellPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
}

- (void)showTextField: (UITextField *) textField withText: (NSString *) text {
    textField.text = text;
    textField.hidden = NO;
}

- (void)didTapSelect:(UIButton*)sender {
    PreviewFlashcard *card = self.previewCards[sender.tag];
    card.isSelected = !card.isSelected;
    [self toggleSelect:![sender isSelected] onButton:sender];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.previewCards count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PreviewCell *cell = (PreviewCell *)[self.previewCarousel cellForItemAtIndexPath:indexPath];
    if (!cell.cardDisplay.isFlipped) {
        [cell.cardDisplay flipAction:cell.cardDisplay.front to:cell.cardDisplay.back];
        cell.cardDisplay.isFlipped = !cell.cardDisplay.isFlipped;
        NSLog(@"front to back");
    } else {
        [cell.cardDisplay flipAction:cell.cardDisplay.back to:cell.cardDisplay.front];
        cell.cardDisplay.isFlipped = !cell.cardDisplay.isFlipped;
        NSLog(@"back to front");
    }
}

- (void)toggleSelect:(BOOL) setSelected onButton:(UIButton *)sender {
    if (setSelected) {
        [sender setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"] forState:UIControlStateSelected];
        [sender setSelected:YES];
    }
    else {
        [sender setImage: [UIImage systemImageNamed:@"circle"] forState:UIControlStateNormal];
        [sender setSelected:NO];
    }
}

- (void) hideEditLabels {
    self.frontTextField.hidden = YES;
    self.backTextField.hidden = YES;
    self.frontTextLabel.hidden = YES;
    self.backTextLabel.hidden = YES;
}

@end
