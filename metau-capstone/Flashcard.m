//
//  Flashcard.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/11/22.
//

#import "Flashcard.h"
#import "PFObject+Subclass.h"

@implementation Flashcard
@dynamic frontText;
@dynamic backText;
@dynamic levelNum;
@dynamic userID;
@dynamic toBeReviewed;

+ (nonnull NSString *)parseClassName {
    return @"Flashcard";
}

+ (void) createCard: ( NSString * _Nullable )frontText withBack: ( NSString * _Nullable )backText withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Flashcard *newCard = [Flashcard new];
    newCard.frontText = frontText;
    newCard.backText = backText;
    newCard.levelNum = @(1);
    newCard.userID = [PFUser currentUser].objectId;
    newCard.toBeReviewed = NO;

    [newCard saveInBackgroundWithBlock: completion];
}

+ (void) cardsFromDictionary: (NSDictionary *)dictionary {
    NSArray * arrayOfFlashcardValues = [dictionary objectForKey:@"values"];
    for (NSArray * flashcardText in arrayOfFlashcardValues) {
        NSString * frontText = flashcardText[0];
        NSString * backText = flashcardText[1];
        [Flashcard createCard:frontText withBack:backText withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"card created!");
            }
            else {
                NSLog(@"nooo cry %@", error.localizedDescription);
            }
        }];
    }
}

@end
