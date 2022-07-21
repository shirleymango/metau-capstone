//
//  ImportViewController.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/21/22.
//

#import "ImportViewController.h"
#import "API/APIManager.h"

@interface ImportViewController ()

@end

@implementation ImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapSubmitImport:(UIButton *)sender {
    
    self.URLTextField.text = @"";
    
    [[APIManager shared] getSheetsData:^(NSError *error) {
        if (!error) {
            NSLog(@"get request");
        } else {
            NSLog(@"😫😫😫 Error getting sheets data: %@", error.localizedDescription);
        }
    }];
}


- (NSString *) pathParameters {
    NSString *pathParametersString = @"";
    NSString *inputString = self.URLTextField.text;
    NSArray *urlBreakdown = [inputString componentsSeparatedByString:@"/"];
    pathParametersString = [pathParametersString stringByAppendingString:urlBreakdown[5]];
    return pathParametersString;
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
