//
//  FlashcardView.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/29/22.
//

#import "FlashcardView.h"

@implementation FlashcardView

- (id) initWithText:(NSString *)text {
    self = [super init];
    if (self) {
        self.front = [[CALayer alloc] init];
        self.front.backgroundColor = [[UIColor blackColor] CGColor];
        self.front.frame = CGRectMake(50, 50, 200, 200);
        self.frontText = [[CATextLayer alloc] init];
        [self.frontText setFont:@"Helvetica-Bold"];
        [self.frontText setFontSize:20];
        [self.frontText setAlignmentMode:kCAAlignmentCenter];
        [self.frontText setString:text];
        [self.frontText setForegroundColor:[[UIColor whiteColor] CGColor]];
        self.frontText.frame = CGRectMake(50, 50, 200, 200);
        [self.layer addSublayer:self.front];
        [self.front addSublayer:self.frontText];
    }
    return self;
}

//- (void) flipAction: (CALayer *) firstSide to: (CALayer *) secondSide{
//    firstSide.transform = CATransform3DMakeRotation(M_PI, 0, -1, 0);
//    secondSide.transform = CATransform3DRotate(CATransform3DMakeRotation(M_PI, 0, 1, 0), M_PI, 0, 1, 0);
//    secondSide.zPosition = 10;
//    firstSide.zPosition = 0;
//}
//
//- (void) createCardBothSides: (CALayer *)layer withFrame: (CGRect) frame withFront:(NSString *) frontString withBack:(NSString *) backString isFlipped:(BOOL)isFlipped {
//    // BACK SIDE
//    self.back = [[CALayer alloc] init];
//    self.backText = [[CATextLayer alloc] init];
//    [self createCardOneSide:self.back atFrame:frame withText:self.backText withBackgroundColor:[UIColor blackColor] withTextColor:[UIColor whiteColor]];
//    [self.backText setString:backString];
//    self.back.zPosition = 0;
//    [self.layer addSublayer:self.back];
//
//    // FRONT SIDE
//    self.front = [[CALayer alloc] init];
//    self.frontText = [[CATextLayer alloc] init];
//    [self createCardOneSide:self.front atFrame:frame withText:self.frontText withBackgroundColor:[UIColor whiteColor] withTextColor:[UIColor blackColor]];
//    [self.frontText setString:frontString];
//    self.front.zPosition = 10;
//    [self.layer addSublayer:self.front];
//
//    self.isFlipped = isFlipped;
//    if (self.isFlipped) {
//        [self flipAction:self.front to:self.back];
//    }
//}
//
//- (void)createCardOneSide:(CALayer *)side atFrame:(CGRect)frame withText:(CATextLayer *)text withBackgroundColor:(UIColor *)bgColor withTextColor:(UIColor *)textColor {
//    side.frame = frame;
//    side.backgroundColor = [bgColor CGColor];
//    side.borderColor = [[UIColor blackColor] CGColor];
//    side.borderWidth = 2;
//    [text setFont:@"Helvetica-Bold"];
//    [text setFontSize:20];
//    [text setAlignmentMode:kCAAlignmentCenter];
//    text.wrapped = YES;
//    [text setFrame:frame];
//    [text setForegroundColor:[textColor CGColor]];
//    [side addSublayer:text];
//}

@end
