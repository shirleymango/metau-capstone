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


+ (nonnull NSString *)parseClassName {
    return @"Flashcard";
}

+ (void) createCard: ( NSString * _Nullable )frontText withBack: ( NSString * _Nullable )backText withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Flashcard *newCard = [Flashcard new];
    newCard.frontText = frontText;
    newCard.backText = backText;

    [newCard saveInBackgroundWithBlock: completion];
}

@end
