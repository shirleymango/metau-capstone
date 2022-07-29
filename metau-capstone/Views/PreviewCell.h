//
//  PreviewCell.h
//  metau-capstone
//
//  Created by Shirley Zhu on 7/27/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreviewCell : UICollectionViewCell

@property (nonatomic, strong) CALayer *front;
@property (nonatomic, strong) CALayer *back;
@property (nonatomic, strong) CATextLayer *frontText;
@property (nonatomic, strong) CATextLayer *backText;
@property (nonatomic, strong) CABasicAnimation *rotateAnim;
@property (nonatomic) CATransform3D horizontalFlip;
@property (nonatomic) BOOL isFlipped;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

- (void) createCardBothSides: (CGRect) frame withFront: (NSString *) frontString withBack: (NSString *) backString;
- (void) flipAction: (CALayer *) firstSide to: (CALayer *) secondSide;

@end

NS_ASSUME_NONNULL_END
