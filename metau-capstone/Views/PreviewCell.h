//
//  PreviewCell.h
//  metau-capstone
//
//  Created by Shirley Zhu on 7/27/22.
//

#import <UIKit/UIKit.h>
#import "FlashcardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PreviewCell : UICollectionViewCell

@property (nonatomic) FlashcardView *cardDisplay;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;


@end

NS_ASSUME_NONNULL_END
