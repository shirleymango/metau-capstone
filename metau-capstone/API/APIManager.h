//
//  APIManager.h
//  metau-capstone
//
//  Created by Shirley Zhu on 7/18/22.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : AFHTTPSessionManager

+ (instancetype)shared;

@property (nonatomic, strong) NSString *APIkey;
@property (nonatomic, strong) NSURL *baseURL;

- (void) getSheetsData: (NSString *) pathParameters withCompletetion:(void(^)(NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
