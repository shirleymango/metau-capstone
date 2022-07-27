//
//  PreviewCell.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/27/22.
//

#import "PreviewCell.h"
#import "QuartzCore/QuartzCore.h"

@implementation PreviewCell

- (void) flipAction: (CALayer *) firstSide to: (CALayer *) secondSide{
    firstSide.transform = CATransform3DMakeRotation(M_PI, 0, -1, 0);
    secondSide.transform = CATransform3DRotate(CATransform3DMakeRotation(M_PI, 0, 1, 0), M_PI, 0, 1, 0);
    secondSide.zPosition = 10;
    firstSide.zPosition = 0;
    self.isFlipped = !self.isFlipped;
}

- (void) createCardBothSides: (CGRect) frame {
    // BACK SIDE
    self.back = [[CALayer alloc] init];
    self.backText = [[CATextLayer alloc] init];
    [self createCardOneSide:self.back atFrame:frame withText:self.backText withBackgroundColor:[UIColor blackColor] withTextColor:[UIColor whiteColor]];
    [self.backText setString:@"back"];
    self.back.zPosition = 0;
    [self.layer addSublayer:self.back];
    
    // FRONT SIDE
    self.front = [[CALayer alloc] init];
    self.frontText = [[CATextLayer alloc] init];
    [self createCardOneSide:self.front atFrame:frame withText:self.frontText withBackgroundColor:[UIColor whiteColor] withTextColor:[UIColor blackColor]];
    [self.frontText setString:@"front :)"];
    self.front.zPosition = 10;
    [self.layer addSublayer:self.front];
}

- (void) createCardOneSide: (CALayer *)side atFrame: (CGRect) frame withText: (CATextLayer *) text withBackgroundColor: (UIColor *) bgColor withTextColor: (UIColor *) textColor {
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
