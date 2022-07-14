//
//  Utilities.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/14/22.
//

#import "Utilities.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"

@interface Utilities ()

@end

@implementation Utilities

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) logout: (SceneDelegate *) sceneDelegate {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        NSLog(@"%@", PFUser.currentUser);
    }];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
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
