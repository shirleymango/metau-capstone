//
//  ImportViewController.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/21/22.
//

#import "ImportViewController.h"
#import "APIManager.h"
#import "SceneDelegate.h"
#import "PreviewViewController.h"

@interface ImportViewController ()

@end

@implementation ImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapSubmitImport:(UIButton *)sender {
    NSString *pathParameters = [self pathParameters];
    NSString *const invalid = @"invalid";
    if (![pathParameters isEqualToString:invalid]) {
        [[APIManager shared] getSheetsData:pathParameters withCompletion:^(NSError *error) {
            if (!error) {
                SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *previewNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"PreviewNavigationController"];
                sceneDelegate.window.rootViewController = previewNavigationController;
                NSLog(@"scene delegate to import page");
            } else {
                NSLog(@"😫😫😫 Error getting sheets data: %@", error.localizedDescription);
            }
        }];
    }
    [self clearFields];
}


- (NSString *) pathParameters {
    NSString *pathParametersString = @"";
    NSString *inputString = self.URLTextField.text;
    NSArray *urlBreakdown = [inputString componentsSeparatedByString:@"/"];
    if ([urlBreakdown count] < 5) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Invalid URL" message:@"Please try again." preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{}];
        pathParametersString = @"invalid";
    }
    else {
        pathParametersString = [pathParametersString stringByAppendingString:urlBreakdown[5]];
        NSString *rangeParameter = [self range];
        pathParametersString = [pathParametersString stringByAppendingString:rangeParameter];
    }
    return pathParametersString;
}

- (NSString *) range {
    NSString *inputStart = self.rangeStartField.text;
    NSString *inputEnd = self.rangeEndField.text;
    NSString *rangeText = @"";
    rangeText = [rangeText stringByAppendingFormat:@"/values/Sheet1!%@:%@", inputStart, inputEnd];
    return rangeText;
}

- (void) clearFields {
    self.URLTextField.text = @"";
    self.rangeStartField.text = @"";
    self.rangeEndField.text = @"";
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
