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
@end

NS_ASSUME_NONNULL_END
