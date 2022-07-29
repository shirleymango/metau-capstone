//
//  PreviewViewController.h
//  metau-capstone
//
//  Created by Shirley Zhu on 7/26/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreviewViewController : UIViewController
@property (nonatomic) NSMutableArray *previewCards;
@property (nonatomic) BOOL editCardIsFlipped;

- (void)showTextField: (UITextField *) textField withText: (NSString *) text;
- (void) setActionForButton: (UIButton *)button withTag: (NSInteger)tag withAction:(SEL) selector;
- (void)frontTextFieldDidChange: (UIButton*)sender;
- (void)backTextFieldDidChange: (UIButton*)sender;
@end

NS_ASSUME_NONNULL_END
