//
//  PreviewFlashcard.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/29/22.
//

#import "PreviewFlashcard.h"
#import "Flashcard.h"
@implementation PreviewFlashcard
+ (PreviewFlashcard *) createPreviewCard: ( NSString * _Nullable )frontText withBack: ( NSString * _Nullable )backText {
    PreviewFlashcard *newCard = [PreviewFlashcard new];
    newCard.frontText = frontText;
    newCard.backText = backText;
    newCard.isSelected = YES;
    return newCard;
}

+ (NSMutableArray *) createCardsFromDictionary: (NSDictionary *)dictionary {
    NSArray *flashcardValues = [dictionary objectForKey:@"values"];
    NSMutableArray *output = [NSMutableArray new];
    for (NSArray * flashcardText in flashcardValues) {
        NSString * frontText = flashcardText[0];
        NSString * backText = flashcardText[1];
        [output addObject:[PreviewFlashcard createPreviewCard:frontText withBack:backText]];
    }
    return output;
}

+ (NSMutableArray *) createCardsFromArray: (NSArray<Flashcard *> *)array {
    NSMutableArray *output = [NSMutableArray new];
    for (Flashcard * card in array) {
        NSString * frontText = card.frontText;
        NSString * backText = card.backText;
        [output addObject:[PreviewFlashcard createPreviewCard:frontText withBack:backText]];
    }
    return output;
}
@end
