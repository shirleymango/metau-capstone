//
//  APIManager.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/18/22.
//

#import "APIManager.h"

@implementation APIManager
+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
@end
