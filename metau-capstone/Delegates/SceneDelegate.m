//
//  SceneDelegate.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/1/22.
//

#import "SceneDelegate.h"
#import "Parse/Parse.h"
#import "Flashcard.h"
#import "PreviewFlashcard.h"
#import "PreviewManager.h"
@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    PFUser *user = [PFUser currentUser];
    if (user != nil) {
        NSLog(@"Welcome back %@ 😀", user.username);
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *tabBarNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
        self.window.rootViewController = tabBarNavigationController;
    }
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    NSURL *url = [URLContexts allObjects][0].URL;
    NSArray *urlComponents = [url.query componentsSeparatedByString:@"&"];
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    for (NSString *keyValuePair in urlComponents)
    {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
        NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
        [queryStringDictionary setObject:value forKey:key];
    }
    NSString *const userIDKey = @"userID";
    NSString *userID = queryStringDictionary[userIDKey];
    
    // Construct Query for Flashcards
    PFQuery *query = [PFQuery queryWithClassName:@"Flashcard"];
    [query whereKey:@"userID" equalTo:userID];
    [query findObjectsInBackgroundWithBlock:^(NSArray<Flashcard *> *cards, NSError * _Nullable error) {
        if (!error) {
            // Create array of Preview Cards
            [PreviewManager shared].previewFlashcards = [PreviewFlashcard createCardsFromArray:cards];
            // Set view controller to preview view controller
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *previewNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"PreviewNavigationController"];
            self.window.rootViewController = previewNavigationController;
        }
    }];
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
