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

@interface StudyViewController ()
@property (nonatomic, strong) CALayer *front;
@property (nonatomic, strong) CALayer *back;
@property (nonatomic, strong) CATextLayer *frontText;
@property (nonatomic, strong) CATextLayer *backText;
@property (nonatomic, strong) CABasicAnimation *rotateAnim;
@property (nonatomic) CATransform3D horizontalFlip;
@property (nonatomic) BOOL isFlipped;
@property (nonatomic, strong) NSArray<Flashcard *> *arrayOfCards;
@property (nonatomic, assign) NSInteger counter;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *congratsLabel;
@property (nonatomic) NSNumber *dayNum;

@end

@implementation StudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser *const user = [PFUser currentUser];
    
    // Instantiate flashcard sides
    // BACK SIDE
    [self instantiateCards];
    
    // create rotation animation
    self.rotateAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    self.rotateAnim.fromValue = [NSNumber numberWithFloat:0];
    self.rotateAnim.toValue = [NSNumber numberWithFloat:(M_PI)];
    self.rotateAnim.duration = 0.8;
    
    self.horizontalFlip = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    
    // Get today's date
    NSLocale* currentLocale = [NSLocale currentLocale];
    NSDate *currentDate = [NSDate date];
    [currentDate descriptionWithLocale:currentLocale];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayDate = [dateFormatter stringFromDate:currentDate];
    
    // Query for prevFinishedDate
    PFQuery *queryForPrevDate = [PFUser query];
    [queryForPrevDate getObjectInBackgroundWithId:user.objectId
                                 block:^(PFObject *userObject, NSError *error) {
        if (userObject) {
            // Check if first time user
            if ([userObject[@"prevFinishedDate"] isEqual:[NSNull null]]) {
                [self endScreen];
            } else if (![todayDate isEqualToString:userObject[@"prevFinishedDate"]]) {
                // PHASE I: Displaying new cards
                if ([userObject[@"phaseNum"] isEqualToNumber:@(4)]) {
                    // Increment day counter for the user
                    [userObject incrementKey:@"userDay"];
                }
                // Fetch today's cards:
                // Fetch today's number for the current user
                self.dayNum = userObject[@"userDay"];
                [userObject saveInBackground];
                NSLog(@"day: %@", self.dayNum);
                // Query for today's level numbers
                PFQuery *queryForLevels = [PFQuery queryWithClassName:@"Schedule"];
                [queryForLevels whereKey:@"dayNum" equalTo:self.dayNum];
                
                [queryForLevels findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                  if (!error) {
                    for (Schedule *object in objects) {
                        NSArray *arrayOfLevels = object.arrayOfLevels;
                        NSString *constraintForCards = @"(userID = %@) AND ";
                        // Construct string containing the level numbers
                        for (int i = 0; i < arrayOfLevels.count; i++) {
                            if (i == 0) {
                                constraintForCards = [constraintForCards stringByAppendingFormat:@"(levelNum = %@)", arrayOfLevels[i]];
                            } else {
                                constraintForCards = [constraintForCards stringByAppendingFormat:@" OR (levelNum = %@)", arrayOfLevels[i]];
                            }
                        }

                        // Construct Query for Flashcards
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:constraintForCards, user.objectId];
                        PFQuery *query = [PFQuery queryWithClassName:@"Flashcard" predicate:predicate];
                        
                        // Fetch data for cards asynchronously
                        [query findObjectsInBackgroundWithBlock:^(NSArray<Flashcard *> *cards, NSError *error) {
                            if (cards != nil) {
                                self.arrayOfCards = cards;
                                NSLog(@"phase 1");
                                self.counter = 0;
                                if ([userObject[@"phaseNum"] isEqualToNumber:@(4)]) {
                                    // Set toBeReviewed to be true for all card
                                    for (Flashcard * cardToBeReviewed in self.arrayOfCards) {
                                        cardToBeReviewed.toBeReviewed = YES;
                                        [cardToBeReviewed saveInBackground];
                                    }
                                    userObject[@"phaseNum"] = @(2);
                                }
                                [self loadFlashcard];
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
                // PHASE IV: Waiting for new cards
                userObject[@"phaseNum"] = @(4);
                [self endScreen];
            }
        } else {
            NSLog(@"no user");
        }
    }];
    
}

- (void) instantiateCards {
    // BACK SIDE
    self.back = [[CALayer alloc] init];
    self.back.frame = CGRectMake(0, 0, 300, 180);
    self.back.backgroundColor = [[UIColor blackColor] CGColor];
    self.back.position = CGPointMake(self.view.center.x, self.view.center.y - 50);
    self.backText = [[CATextLayer alloc] init];
    [self.backText setFont:@"Helvetica-Bold"];
    [self.backText setFontSize:20];
    [self.backText setAlignmentMode:kCAAlignmentCenter];
    self.backText.wrapped = YES;
    [self.backText setForegroundColor:[[UIColor whiteColor] CGColor]];
    [self.backText setFrame:CGRectMake(0, 0, 300, 180)];
    [self.back addSublayer:self.backText];
    
    // FRONT SIDE
    self.front = [[CALayer alloc] init];
    self.front.frame = CGRectMake(0, 0, 300, 180);
    self.front.backgroundColor = [[UIColor whiteColor] CGColor];
    self.front.position = CGPointMake(self.view.center.x, self.view.center.y - 50);
    self.frontText = [[CATextLayer alloc] init];
    [self.frontText setFont:@"Helvetica-Bold"];
    [self.frontText setFontSize:20];
    [self.frontText setAlignmentMode:kCAAlignmentCenter];
    self.frontText.wrapped = YES;
    [self.frontText setForegroundColor:[[UIColor blackColor] CGColor]];
    [self.frontText setFrame:CGRectMake(0, 0, 300, 180)];
    [self.front addSublayer:self.frontText];
}

- (void) loadFlashcard {
    if (self.isFlipped) {
        self.front.transform = CATransform3DRotate(self.horizontalFlip, M_PI, 0, 1, 0);
        self.back.transform = CATransform3DMakeRotation(M_PI, 0, -1, 0);
        self.isFlipped = NO;
        self.front.zPosition = 10;
        self.back.zPosition = 0;
        NSLog(@"to front");
    }
    if (self.counter < self.arrayOfCards.count) {
        self.leftButton.hidden = NO;
        self.rightButton.hidden = NO;
        self.congratsLabel.hidden = YES;
        
        Flashcard *card = self.arrayOfCards[self.counter];
        
        // PHASE II: Middle of studying cards
        // Only display cards that have not been reviewed yet
        if (!card.toBeReviewed) {
            self.counter++;
            [self loadFlashcard];
        } else {
            // BACK SIDE
            // add text label to the flashcard
            [self.backText setString:card.backText];
            self.back.transform = CATransform3DMakeRotation(M_PI, 0, -1, 0);
            [self.view.layer addSublayer:self.back];
            
            // FRONT SIDE
            // add text label to the flashcard
            [self.frontText setString:card.frontText];
            [self.view.layer addSublayer:self.front];
        }
    } else {
        // PHASE III: Finished studying cards
        NSLog(@"reached end of stack");
        userObject[@"phaseNum"] = @(3);
        [self endScreen];
        
        NSLocale* currentLocale = [NSLocale currentLocale];
        NSDate *currentDate = [NSDate date];
        [currentDate descriptionWithLocale:currentLocale];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        
        PFUser *const user = [PFUser currentUser];
        PFQuery *query = [PFUser query];
        // Retrieve the object by id
        [query getObjectInBackgroundWithId:user.objectId
                                     block:^(PFObject *userObject, NSError *error) {
            if (userObject) {
                // Update lastFinished date
                userObject[@"prevFinishedDate"] = dateString;
                [userObject saveInBackground];
            }
            else {
                NSLog(@"no user");
            }
        }];
    }
}

- (void) endScreen {
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    self.congratsLabel.hidden = NO;
    
    // BACK SIDE
    // add text label to the flashcard
    [self.backText setString:@"Come back tomorrow for your new stack :-)"];
    self.back.transform = CATransform3DMakeRotation(M_PI, 0, -1, 0);
    [self.view.layer addSublayer:self.back];
    
    // FRONT SIDE
    // add text label to the flashcard
    [self.frontText setString:@"You finished studying today's cards!"];
    [self.view.layer addSublayer:self.front];
}

- (IBAction)didTapRight:(UIButton *)sender {
    // Update level
    PFQuery *query = [PFQuery queryWithClassName:@"Flashcard"];
    Flashcard *card = self.arrayOfCards[self.counter];
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:card.objectId
                                 block:^(PFObject *card, NSError *error) {
        [card incrementKey:@"levelNum"];
        [card saveInBackground];
        
        // Update card as no longer needing to be reviewed
        card[@"toBeReviewed"] = @NO;
        [card saveInBackground];
    }];
    
    self.counter++;
    [self loadFlashcard];
}

- (IBAction)didTapLeft:(UIButton *)sender {
    // Reset level
    Flashcard *card = self.arrayOfCards[self.counter];
    [self resetCard:card];
    // Update card as no longer needing to be reviewed
    card[@"toBeReviewed"] = @NO;
    [card saveInBackground];
    self.counter++;
    [self loadFlashcard];
}

- (IBAction)didTapScreen:(UITapGestureRecognizer *)sender {
    if (!self.isFlipped) {
        self.front.transform = CATransform3DMakeRotation(M_PI, 0, -1, 0);
        self.back.transform = CATransform3DRotate(self.horizontalFlip, M_PI, 0, 1, 0);
        self.isFlipped = YES;
        self.back.zPosition = 10;
        self.front.zPosition = 0;
        NSLog(@"to back");
    } else {
        self.front.transform = CATransform3DRotate(self.horizontalFlip, M_PI, 0, 1, 0);
        self.back.transform = CATransform3DMakeRotation(M_PI, 0, -1, 0);
        self.isFlipped = NO;
        self.front.zPosition = 10;
        self.back.zPosition = 0;
        NSLog(@"to front");
    }
}

- (void) resetCard: (Flashcard *) card {
    PFQuery *query = [PFQuery queryWithClassName:@"Flashcard"];
    [query getObjectInBackgroundWithId:card.objectId
                                 block:^(PFObject *card, NSError *error) {
        card[@"levelNum"] = @(1);
        [card saveInBackground];
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
- (IBAction)didTapLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    Utilities* utility = [[Utilities alloc] init];
    [utility logout: sceneDelegate];
}

@end
