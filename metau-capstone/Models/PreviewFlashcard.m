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
@end
