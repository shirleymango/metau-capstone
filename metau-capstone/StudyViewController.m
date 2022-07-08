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
@property (nonatomic, strong) CALayer *front;
@property (nonatomic, strong) CALayer *back;
@property (nonatomic, strong) CABasicAnimation *rotateAnim;
@property (nonatomic) CATransform3D horizontalFlip;
@property (nonatomic) BOOL isFlipped;
@end

@implementation StudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //BACK SIDE
    self.back = [[CALayer alloc] init];
    self.back.frame = CGRectMake(0, 0, 300, 180);
    self.back.backgroundColor = [[UIColor blackColor] CGColor];
    self.back.position = CGPointMake(self.view.center.x, self.view.center.y - 50);
    
    // add text label to the flashcard
    CATextLayer *backLabel = [[CATextLayer alloc] init];
    [backLabel setFont:@"Helvetica-Bold"];
    [backLabel setFontSize:20];
    [backLabel setString:@"Back"];
    [backLabel setAlignmentMode:kCAAlignmentCenter];
    [backLabel setForegroundColor:[[UIColor whiteColor] CGColor]];
    [backLabel setFrame:CGRectMake(0, 0, 300, 180)];
    [self.back addSublayer:backLabel];
    self.back.transform = CATransform3DMakeRotation(M_PI, 0, -1, 0);
    [self.view.layer addSublayer:self.back];
    
    // FRONT SIDE
    // create the flashcard
    self.front = [[CALayer alloc] init];
    self.front.frame = CGRectMake(0, 0, 300, 180);
    self.front.backgroundColor = [[UIColor whiteColor] CGColor];
    self.front.position = CGPointMake(self.view.center.x, self.view.center.y - 50);
    
    // add text label to the flashcard
    CATextLayer *label = [[CATextLayer alloc] init];
    [label setFont:@"Helvetica-Bold"];
    [label setFontSize:20];
    [label setString:@"Front"];
    [label setAlignmentMode:kCAAlignmentCenter];
    [label setForegroundColor:[[UIColor blackColor] CGColor]];
    [label setFrame:CGRectMake(0, 0, 300, 180)];
    [self.front addSublayer:label];
    
    [self.view.layer addSublayer:self.front];
    
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
        self.front.transform = CATransform3DMakeRotation(M_PI, 0, -1, 0);
        self.back.transform = CATransform3DRotate(self.horizontalFlip, M_PI, 0, 1, 0);
        self.isFlipped = YES;
        self.back.zPosition = 10;
        self.front.zPosition = 0;
        NSLog(@"to back");
    }
    else {
        self.front.transform = CATransform3DRotate(self.horizontalFlip, M_PI, 0, 1, 0);
        self.back.transform = CATransform3DMakeRotation(M_PI, 0, -1, 0);
        self.isFlipped = NO;
        self.front.zPosition = 10;
        self.back.zPosition = 0;
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
