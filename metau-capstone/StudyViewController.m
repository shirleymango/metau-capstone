//
//  StudyViewController.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/6/22.
//

#import "StudyViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
@interface StudyViewController ()
@property (nonatomic, strong) CALayer *layer;
@property (nonatomic, strong) CABasicAnimation *rotateAnim;
@end

@implementation StudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.layer = [[CALayer alloc] init];
    self.layer.frame = CGRectMake(0, 0, 300, 180);
    self.layer.backgroundColor = [[UIColor blackColor] CGColor];
    self.layer.position = CGPointMake(self.view.center.x, self.view.center.y - 50);
    [self.view.layer addSublayer:self.layer];
    
    self.rotateAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    self.rotateAnim.fromValue = [NSNumber numberWithFloat:0];
    self.rotateAnim.toValue = [NSNumber numberWithFloat:(360 * M_PI / 180.0f)];
    self.rotateAnim.duration = 2.5;
}

- (IBAction)didTapScreen:(UITapGestureRecognizer *)sender {
    [self.layer addAnimation:self.rotateAnim forKey:@"rotationAnimation"];
//    self.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
}

@end
