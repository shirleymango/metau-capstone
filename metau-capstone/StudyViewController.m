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
@property (nonatomic) CATransform3D horizontalFlip;
@property (nonatomic) BOOL isFlipped;
@end

@implementation StudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // create the flashcard
    self.layer = [[CALayer alloc] init];
    self.layer.frame = CGRectMake(0, 0, 300, 180);
    self.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    self.layer.position = CGPointMake(self.view.center.x, self.view.center.y - 50);
    
    // add text label to the flashcard
    CATextLayer *label = [[CATextLayer alloc] init];
    [label setFont:@"Helvetica-Bold"];
    [label setFontSize:20];
    [label setString:@"Hello"];
    [label setAlignmentMode:kCAAlignmentCenter];
    [label setForegroundColor:[[UIColor blackColor] CGColor]];
    [label setFrame:CGRectMake(0, 0, 300, 180)];
    [self.layer addSublayer:label];
    
    [self.view.layer addSublayer:self.layer];
    
    // create rotation animation
    self.rotateAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    self.rotateAnim.fromValue = [NSNumber numberWithFloat:0];
    self.rotateAnim.toValue = [NSNumber numberWithFloat:(M_PI)];
    self.rotateAnim.duration = 0.8;
    
    self.horizontalFlip = CATransform3DMakeRotation(M_PI, 0, 1, 0);
}

- (IBAction)didTapScreen:(UITapGestureRecognizer *)sender {
    // call rotation animation on flashcard
//    [self.layer addAnimation:self.rotateAnim forKey:@"rotationAnimation"];
    
    if (!self.isFlipped) {
        self.layer.transform = CATransform3DMakeRotation(M_PI, 0, -1, 0);
        self.isFlipped = YES;
        NSLog(@"to back");
    }
    else {
        self.layer.transform = CATransform3DRotate(self.horizontalFlip, M_PI, 0, 1, 0);
        self.isFlipped = NO;
        NSLog(@"to front");
    }
//    [self.layer setTransform:CATransform3DMakeRotation(M_PI, 0, 1, 0)];
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
