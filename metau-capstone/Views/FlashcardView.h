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
//@property (nonatomic, strong) CALayer *back;
@property (nonatomic, strong) CATextLayer *frontText;
- (id) initWithText:(NSString *)text;
//@property (nonatomic, strong) CATextLayer *backText;
//@property (nonatomic, strong) CABasicAnimation *rotateAnim;
//@property (nonatomic) CATransform3D horizontalFlip;
//@property (nonatomic) BOOL isFlipped;
//- (void) createCardBothSides: (CALayer *)layer withFrame: (CGRect) frame withFront: (NSString *) frontString withBack: (NSString *) backString isFlipped:(BOOL)isFlipped;
//- (void) flipAction: (CALayer *) firstSide to: (CALayer *) secondSide;
@end

NS_ASSUME_NONNULL_END
