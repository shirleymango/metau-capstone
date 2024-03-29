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
#import "Utilities.h"
#import "APIManager.h"
#import "ImportViewController.h"
#import "FlashcardView.h"

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
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Success ^-^ !!" message:@"Your flashcard was created." preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{}];
        }
        else {
            NSLog(@"nooo cry %@", error.localizedDescription);
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:error.localizedDescription message:@"Please try again." preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{}];
        }
    }];
}

- (IBAction)didTapImport:(UIButton *)sender {
    [self performSegueWithIdentifier:@"importSegue" sender:nil];
}


- (IBAction)didTapShare:(id)sender {
    NSURL *url = [self userURL];
    [self presentShareActiviyViewController:url];
}

// Construct user URL
- (NSURL *)userURL {
    NSURL *url= [[NSURL alloc] init];
    PFUser *const user = [PFUser currentUser];
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"com.shirleyzhu.metau-capstone";
    components.host = @"floofcards";
    components.query = [@"userID=" stringByAppendingFormat:@"%@", user.objectId];
    url = components.URL;
    return url;
}

// Add share feature UI
- (void) presentShareActiviyViewController: (NSURL *)url {
    NSString * title =[NSString stringWithFormat:@"Share my flashcards to a friend"];
    NSArray* dataToShare = @[title, url];
    UIActivityViewController* activityViewController =[[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
    if (activityViewController == nil){
        return;
    }
    [self presentViewController:activityViewController animated:YES completion:^{}];
}

- (IBAction)didTapLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    Utilities* utility = [[Utilities alloc] init];
    [utility logout: sceneDelegate];
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
