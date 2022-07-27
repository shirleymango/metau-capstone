//
//  PreviewCell.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/27/22.
//

#import "PreviewCell.h"

@implementation PreviewCell

- (void) createFlipAnimation {
    self.rotateAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    self.rotateAnim.fromValue = [NSNumber numberWithFloat:0];
    self.rotateAnim.toValue = [NSNumber numberWithFloat:(M_PI)];
    self.rotateAnim.duration = 0.8;
    self.horizontalFlip = CATransform3DMakeRotation(M_PI, 0, 1, 0);
}

- (void) flipAction: (CALayer *) firstSide to: (CALayer *) secondSide{
    firstSide.transform = CATransform3DMakeRotation(M_PI, 0, -1, 0);
    secondSide.transform = CATransform3DRotate(self.horizontalFlip, M_PI, 0, 1, 0);
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
    self.back.transform = CATransform3DMakeRotation(M_PI, 0, -1, 0);
    [self.layer addSublayer:self.back];
    
    // FRONT SIDE
    self.front = [[CALayer alloc] init];
    self.frontText = [[CATextLayer alloc] init];
    [self createCardOneSide:self.front atFrame:frame withText:self.frontText withBackgroundColor:[UIColor whiteColor] withTextColor:[UIColor blackColor]];
    [self.frontText setString:@"front :)"];
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
