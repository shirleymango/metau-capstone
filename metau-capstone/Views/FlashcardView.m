//
//  FlashcardView.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/29/22.
//

#import "FlashcardView.h"

@implementation FlashcardView

- (id) initWithText:(CGRect)frame withFront:(NSString *)frontString withBack:(NSString *)backString isFlipped:(BOOL)isFlipped {
    self = [super init];
    if (self) {
        // BACK
        self.back = [[CALayer alloc] init];
        self.backText = [[CATextLayer alloc] init];
        [self.backText setString:backString];
        self.back.transform = CATransform3DMakeRotation(M_PI, 0, -1, 0);
        [self.layer addSublayer:self.back];
        [self createCardOneSide:self.back atFrame:frame withText:self.backText withBackgroundColor:[UIColor blackColor] withTextColor:[UIColor whiteColor]];
        
        //FRONT
        self.front = [[CALayer alloc] init];
        self.frontText = [[CATextLayer alloc] init];
        [self.frontText setString:frontString];
        [self.layer addSublayer:self.front];
        [self createCardOneSide:self.front atFrame:frame withText:self.frontText withBackgroundColor:[UIColor whiteColor] withTextColor:[UIColor blackColor]];
        
        self.isFlipped = isFlipped;
        if (self.isFlipped) {
            [self flipAction:self.front to:self.back];
        }
    }
    return self;
}

- (void) updateTextOnCard:(NSString *)frontString withBack:(NSString *)backString {
    // BACK SIDE
    [self.backText setString:backString];
    self.back.transform = CATransform3DMakeRotation(M_PI, 0, -1, 0);
    [self.layer addSublayer:self.back];
    // FRONT SIDE
    [self.frontText setString:frontString];
    [self.layer addSublayer:self.front];
    self.isFlipped = NO;
}

- (void) flipAction: (CALayer *) firstSide to: (CALayer *) secondSide{
    firstSide.transform = CATransform3DMakeRotation(M_PI, 0, -1, 0);
    secondSide.transform = CATransform3DRotate(CATransform3DMakeRotation(M_PI, 0, 1, 0), M_PI, 0, 1, 0);
    secondSide.zPosition = 10;
    firstSide.zPosition = 0;
}

- (void)createCardOneSide:(CALayer *)side atFrame:(CGRect)frame withText:(CATextLayer *)text withBackgroundColor:(UIColor *)bgColor withTextColor:(UIColor *)textColor {
    side.frame = frame;
    side.backgroundColor = [bgColor CGColor];
    side.borderColor = [[UIColor blackColor] CGColor];
    side.borderWidth = 2;
    [text setFont:@"Helvetica-Bold"];
    [text setFontSize:20];
    [text setAlignmentMode:kCAAlignmentCenter];
    text.wrapped = YES;
    [text setFrame:frame];
    [text setForegroundColor:[textColor CGColor]];
    [side addSublayer:text];
}

@end
