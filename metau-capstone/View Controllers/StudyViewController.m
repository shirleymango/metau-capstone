//
//  StudyViewController.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/6/22.
//

#import "StudyViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "Flashcard.h"
#import "Schedule.h"
#import "Utilities.h"
#import "CircleProgressBar.h"
#import "FlashcardView.h"

@interface StudyViewController ()
@property (nonatomic) FlashcardView *flashcard;
@property (nonatomic, strong) NSArray<Flashcard *> *arrayOfCards;
@property (nonatomic, assign) NSInteger counter;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *congratsLabel;
@property (nonatomic) NSNumber *dayNum;
@property (nonatomic) NSString *prevFinishedDate;
@property (weak, nonatomic) IBOutlet CircleProgressBar *circleProgressBar;
@property (nonatomic) CGFloat percentFinished;

@end

@implementation StudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.flashcard = [[FlashcardView alloc] initWithText:CGRectMake(0, 0, 300, 180) withFront:@"front" withBack:@"back" isFlipped:NO];
    self.flashcard.back.position = CGPointMake(self.view.center.x, self.view.center.y - 50);
    self.flashcard.front.position = CGPointMake(self.view.center.x, self.view.center.y - 50);
    [self.view addSubview:self.flashcard];
    
    PFUser *const user = [PFUser currentUser];
    self.prevFinishedDate = user[@"prevFinishedDate"];
    
    self.percentFinished = [user[@"percentFinished"] doubleValue];
    [self.circleProgressBar setProgress:self.percentFinished animated:YES];
    
    if ([self isFirstTimeUser] || [self isNewDay]) {
        // Check user has started reviewing for the day
        if (![self isFirstTimeUser] && [user[@"didStartReview"] isEqual:@NO]) {
            // Increment day counter for the user
            [user incrementKey:@"userDay"];
            [user saveInBackground];
            // Reset progress bar to zero percent
            user[@"percentFinished"] = @(0);
            self.percentFinished = [user[@"percentFinished"] doubleValue];
            [self.circleProgressBar setProgress:self.percentFinished animated:YES];
        }
        
        // Fetch today's number for the current user
        self.dayNum = user[@"userDay"];
        
        // Query for today's level numbers
        PFQuery *queryForLevels = [PFQuery queryWithClassName:@"Schedule"];
        [queryForLevels whereKey:@"dayNum" equalTo:self.dayNum];
        
        [queryForLevels findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (Schedule *object in objects) {
                    NSArray *arrayOfLevels = object.arrayOfLevels;
                    NSString *constraintForCards = [self stringWithLevels:arrayOfLevels];
                    
                    // Construct Query for Flashcards
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:constraintForCards, user.objectId];
                    PFQuery *query = [PFQuery queryWithClassName:@"Flashcard" predicate:predicate];
                    
                    // Fetch data for cards asynchronously
                    [query findObjectsInBackgroundWithBlock:^(NSArray<Flashcard *> *cards, NSError *error) {
                        if (cards != nil) {
                            self.arrayOfCards = cards;
                            self.counter = 0;
                            if ([cards count] == 0) {
                                [self startScreen];
                            } else {
                                if ([user[@"didStartReview"] isEqual:@NO]) {
                                    // Set toBeReviewed to be true for all card
                                    for (Flashcard * cardToBeReviewed in self.arrayOfCards) {
                                        cardToBeReviewed.toBeReviewed = YES;
                                        [cardToBeReviewed saveInBackground];
                                    }
                                    user[@"didStartReview"] = @YES;
                                    [user saveInBackground];
                                }
                                // Display flashcards
                                [self loadFlashcard];
                            }
                        } else {
                            NSLog(@"%@", error.localizedDescription);
                        }
                    }];
                }
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
    } else {
        // Waiting for new cards
        [self endScreen];
    }
}

- (BOOL) isNewDay {
    return ![[self todayDate] isEqualToString:self.prevFinishedDate];
}

- (BOOL) isFirstTimeUser {
    return [self.prevFinishedDate isEqual:[NSNull null]];
}

- (NSString *) stringWithLevels: (NSArray *) arrayOfLevels{
    NSString *constraintForCards = @"(userID = %@) AND ";
    for (int i = 0; i < arrayOfLevels.count; i++) {
        if (i == 0) {
            constraintForCards = [constraintForCards stringByAppendingFormat:@"(levelNum = %@", arrayOfLevels[i]];
        } else {
            constraintForCards = [constraintForCards stringByAppendingFormat:@" OR levelNum = %@", arrayOfLevels[i]];
        }
    }
    constraintForCards = [constraintForCards stringByAppendingString: @")"];
    return constraintForCards;
}


- (NSString *) todayDate {
    NSLocale* currentLocale = [NSLocale currentLocale];
    NSDate *currentDate = [NSDate date];
    [currentDate descriptionWithLocale:currentLocale];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:currentDate];
}

- (void) loadFlashcard {
    if (self.flashcard.isFlipped) {
        [self.flashcard flipAction:self.flashcard.back to:self.flashcard.front];
    }
    if (self.counter < self.arrayOfCards.count) {
        self.leftButton.hidden = NO;
        self.rightButton.hidden = NO;
        self.congratsLabel.hidden = YES;
        
        Flashcard *card = self.arrayOfCards[self.counter];
        // Only display cards that have not been reviewed yet
        if (!card.toBeReviewed) {
            [self loadNextCard];
        } else {
            [self.flashcard updateTextOnCard:card.frontText withBack:card.backText];
        }
    } else {
        // End of stack
        NSLog(@"reached end of stack");
        [self endScreen];
        
        NSString *dateString = [self todayDate];
        PFUser *const user = [PFUser currentUser];
        // Update lastFinished date
        user[@"prevFinishedDate"] = dateString;
        [user saveInBackground];
        
        user[@"didStartReview"] = @NO;
        [user saveInBackground];
    }
}

- (void) startScreen {
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    self.congratsLabel.hidden = YES;
    [self.flashcard updateTextOnCard:@"You have no cards yet! \r Add cards by going to the Create tab." withBack:@"Come back afterwards to study your cards :)"];
}

- (void) endScreen {
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    self.congratsLabel.hidden = NO;
    [self.flashcard updateTextOnCard:@"You finished studying today's cards!" withBack:@"Come back tomorrow for your new stack :-)"];
}

- (IBAction)didTapRight:(UIButton *)sender {
    [self incrementCircleProgress];
    Flashcard *card = self.arrayOfCards[self.counter];
    // Update level
    [card incrementKey:@"levelNum"];
    [card saveInBackground];
    // Update card as no longer needing to be reviewed
    card[@"toBeReviewed"] = @NO;
    [card saveInBackground];
    [self loadNextCard];
}

- (IBAction)didTapLeft:(UIButton *)sender {
    [self incrementCircleProgress];
    Flashcard *card = self.arrayOfCards[self.counter];
    // Reset level
    [self resetCard:card];
    // Update card as no longer needing to be reviewed
    card[@"toBeReviewed"] = @NO;
    [card saveInBackground];
    [self loadNextCard];
}

- (IBAction)didTapScreen:(UITapGestureRecognizer *)sender {
    if (!self.flashcard.isFlipped) {
        [self.flashcard flipAction:self.flashcard.front to:self.flashcard.back];
    } else {
        [self.flashcard flipAction:self.flashcard.back to:self.flashcard.front];
    }
    self.flashcard.isFlipped = !self.flashcard.isFlipped;
}

- (void) resetCard: (Flashcard *) card {
    PFQuery *query = [PFQuery queryWithClassName:@"Flashcard"];
    [query getObjectInBackgroundWithId:card.objectId
                                 block:^(PFObject *card, NSError *error) {
        card[@"levelNum"] = @(1);
        [card saveInBackground];
    }];
}

- (void) loadNextCard {
    self.counter++;
    [self loadFlashcard];
}

- (CGFloat) progressPercentIncrement {
    return 1.0/[self.arrayOfCards count];
}

- (void) incrementCircleProgress {
    self.percentFinished += [self progressPercentIncrement];
    [self.circleProgressBar setProgress:self.percentFinished animated:YES];
    PFUser *const user = [PFUser currentUser];
    user[@"percentFinished"] = @(self.percentFinished);
    [user saveInBackground];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)didTapLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    Utilities* utility = [[Utilities alloc] init];
    [utility logout: sceneDelegate];
}

- (void) viewWillAppear:(BOOL)animated {
    PFUser *const user = [PFUser currentUser];
    PFQuery *queryForCards = [PFQuery queryWithClassName:@"Flashcard"];
    [queryForCards whereKey:@"userID" equalTo:user.objectId];
    [queryForCards findObjectsInBackgroundWithBlock:^(NSArray * _Nullable cards, NSError * _Nullable error) {
        self.arrayOfCards = cards;
        self.counter = 0;
        self.prevFinishedDate = user[@"prevFinishedDate"];
        if ([cards count] == 0) {
            [self startScreen];
        } else if ([self isFirstTimeUser]) {
            NSLog(@"howdy first time user");
            if ([user[@"didStartReview"] isEqual:@NO]) {
                // Set toBeReviewed to be true for all card
                for (Flashcard * cardToBeReviewed in self.arrayOfCards) {
                    cardToBeReviewed.toBeReviewed = YES;
                    [cardToBeReviewed saveInBackground];
                }
                user[@"didStartReview"] = @YES;
                [user saveInBackground];
            }
            // Display flashcards
            [self loadFlashcard];
        }
    }];
}

@end
