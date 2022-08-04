//
//  AppDelegate.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/1/22.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"
#import "FirebaseDynamicLinks.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Info" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];

    NSString *key = [dict objectForKey: @"parse_client_key"];
    NSString *secret = [dict objectForKey: @"parse_app_ID"];
    
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {

        configuration.applicationId = secret;
        configuration.clientKey = key;
        configuration.server = @"https://parseapi.back4app.com";
    }];

    [Parse initializeWithConfiguration:config];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"open url through custom url scheme");
    return YES;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
