//
//  ScheduleViewController.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/6/22.
//

#import "ScheduleViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "Schedule.h"

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    for (int i = 4; i <= 64; i+=8) {
        // Retrieve the day
        if (i != 4 && i % 2 == 0) {
            // if i is even and not 4, add 1
            i++;
        }
        else if (i % 2 == 1) {
            i--;
        }
        PFQuery *query = [PFQuery queryWithClassName:@"Schedule"];
        NSNumber *currentDay = [NSNumber numberWithInt:i];
        [query whereKey:@"dayNum" equalTo:currentDay];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (objects != nil) {
                Schedule *day = objects[0];
                NSLog(@"%@", day.dayNum);
                [day addObject:@(4) forKey:@"arrayOfLevels"];
                [day saveInBackground];
            }
        }];
        
        // add to the array
    }
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
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
