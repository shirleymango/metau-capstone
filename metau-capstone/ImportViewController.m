//
//  ImportViewController.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/21/22.
//

#import "ImportViewController.h"

@interface ImportViewController ()

@end

@implementation ImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapSubmitImport:(UIButton *)sender {
    NSString *inputString = self.URLTextField.text;
    NSLog(@"%@", inputString);
    NSArray *urlBreakdown = [inputString componentsSeparatedByString:@"/"];
    NSLog(@"%@", urlBreakdown[5]);
    
    self.URLTextField.text = @"";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
