//
//  APIManager.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/18/22.
//

#import "APIManager.h"
#import "Flashcard.h"
#import "PreviewViewController.h"
#import "PreviewCard.h"

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
    NSLog(@"API: %@", self.APIkey);
    
    return self;
}

- (void) getSheetsData: (NSString *) pathParameters withCompletion: (void(^)(NSError *error))completion {
    NSDictionary *parameters = @{@"key": self.APIkey};
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *endURLString = [@"v4/spreadsheets/" stringByAppendingString:pathParameters];
    [manager GET:endURLString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable sheetDictionary) {
        // Success
        [PreviewCard createCardsFromDictionary:sheetDictionary];
        NSLog(@"posted preview cards!");
        completion(nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(error);
        NSLog(@":''(");
    }];
    
}


@end
