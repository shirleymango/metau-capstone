//
//  PreviewCard.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/28/22.
//

#import "PreviewCard.h"

@implementation PreviewCard
@dynamic frontText;
@dynamic backText;
@dynamic isSelected;
@dynamic userID;

+ (nonnull NSString *)parseClassName {
    return @"PreviewCard";
}

+ (void) createPreviewCard: ( NSString * _Nullable )frontText withBack: ( NSString * _Nullable )backText {
    PreviewCard *newCard = [PreviewCard new];
    newCard.frontText = frontText;
    newCard.backText = backText;
    newCard.isSelected = YES;
    newCard.userID = [PFUser currentUser].objectId;
    [newCard saveInBackground];
}

+ (void) createCardsFromDictionary: (NSDictionary *)dictionary {
    NSArray * flashcardValues = [dictionary objectForKey:@"values"];
    for (NSArray * flashcardText in flashcardValues) {
        NSString * frontText = flashcardText[0];
        NSString * backText = flashcardText[1];
        [PreviewCard createPreviewCard:frontText withBack:backText];
    }
}
@end
