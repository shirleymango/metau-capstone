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
    FlashcardView *testCard = [[FlashcardView alloc] initWithText:@"aloha"];
    [self.view addSubview:testCard];
    
    UIView *paintView=[[UIView alloc]initWithFrame:CGRectMake(0, 50, 320, 430)];
    [paintView setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:paintView];
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
