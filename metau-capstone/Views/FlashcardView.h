//
//  FlashcardView.h
//  metau-capstone
//
//  Created by Shirley Zhu on 7/29/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlashcardView : UIView
@property (nonatomic, strong) CALayer *front;
@property (nonatomic, strong) CALayer *back;
@property (nonatomic, strong) CATextLayer *frontText;
@property (nonatomic, strong) CATextLayer *backText;
@property (nonatomic) BOOL isFlipped;
/**
 * Initializes and returns a FlashcardView object using the provided strings for text.
 *
 * @param frame A rectangle that represents frame for the card display.
 * @param frontString A string that represents text on the front of the card display.
 * @param backString A string that represents text on the back of the card display.
 * @param isFlipped A boolean that represents whether a card is flipped or not.
 */
- (id) initWithText:(CGRect)frame withFront:(NSString *) frontString withBack:(NSString *)backString isFlipped:(BOOL)isFlipped;
- (void) flipAction: (CALayer *) firstSide to: (CALayer *) secondSide;
- (void) updateTextOnCard:(NSString *)frontString withBack:(NSString *)backString;
@end

NS_ASSUME_NONNULL_END
