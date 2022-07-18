//
//  APIManager.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/18/22.
//

#import "APIManager.h"

static NSString * const baseURLString = @"https://sheets.googleapis.com";

@interface APIManager()

@end

@implementation APIManager
+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self.baseURL = [NSURL URLWithString:baseURLString];
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Info" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    self.APIkey = [dict objectForKey: @"sheets_api_key"];
    
    return self;
}

@end
