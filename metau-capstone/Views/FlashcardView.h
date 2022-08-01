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
- (id) initWithText:(CGRect)frame withFront:(NSString *) frontString withBack:(NSString *)backString isFlipped:(BOOL)isFlipped;
- (void) flipAction: (CALayer *) firstSide to: (CALayer *) secondSide;
@property (nonatomic) BOOL isFlipped;
//@property (nonatomic, strong) CABasicAnimation *rotateAnim;
//@property (nonatomic) CATransform3D horizontalFlip;
//- (void) createCardBothSides: (CALayer *)layer withFrame: (CGRect) frame withFront: (NSString *) frontString withBack: (NSString *) backString isFlipped:(BOOL)isFlipped;
@end

NS_ASSUME_NONNULL_END
