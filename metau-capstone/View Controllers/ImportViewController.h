//
//  ImportViewController.h
//  metau-capstone
//
//  Created by Shirley Zhu on 7/21/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImportViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *URLTextField;
@property (weak, nonatomic) IBOutlet UITextField *rangeStartField;
@property (weak, nonatomic) IBOutlet UITextField *rangeEndField;

@end

NS_ASSUME_NONNULL_END
