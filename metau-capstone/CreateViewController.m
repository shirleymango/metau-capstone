//
//  CreateViewController.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/6/22.
//

#import "CreateViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "Flashcard.h"

@interface CreateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *frontTextField;
@property (weak, nonatomic) IBOutlet UITextField *backTextField;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapSubmit:(UIButton *)sender {
    NSLog(@"%@", self.frontTextField.text);
    
    [Flashcard createCard: self.frontTextField.text withBack: self.backTextField.text withCompletion:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"success in creating card ^-^!");
            self.frontTextField.text = @"";
            self.backTextField.text = @"";
        }
        else {
            NSLog(@"nooo cry %@", error.localizedDescription);
        }
    }];
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
