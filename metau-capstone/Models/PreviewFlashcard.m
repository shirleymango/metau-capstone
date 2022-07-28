//
//  PreviewFlashcard.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/28/22.
//

#import "PreviewFlashcard.h"

@implementation PreviewFlashcard

+ (void) createPreviewCard: ( NSString * _Nullable )frontText withBack: ( NSString * _Nullable )backText {
    PreviewFlashcard *newCard = [[PreviewFlashcard alloc] init];
    newCard.frontText = frontText;
    newCard.backText = backText;
    newCard.isSelected = YES;
}

+ (void) createCardsFromDictionary: (NSDictionary *)dictionary {
    NSArray * flashcardValues = [dictionary objectForKey:@"values"];
    for (NSArray * flashcardText in flashcardValues) {
        NSString * frontText = flashcardText[0];
        NSString * backText = flashcardText[1];
        [PreviewFlashcard createPreviewCard:frontText withBack:backText];
    }
}

@end
