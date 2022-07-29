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
-(void)showTextField: (UITextField *) textField withText: (NSString *) text;
@end

NS_ASSUME_NONNULL_END
