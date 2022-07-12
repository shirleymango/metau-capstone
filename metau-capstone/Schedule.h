//
//  Schedule.h
//  metau-capstone
//
//  Created by Shirley Zhu on 7/12/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Schedule : PFObject <PFSubclassing>
@property (nonatomic, strong) NSArray *arrayOfLevels;
@property (nonatomic, strong) NSNumber *dayNum;

+ (void) createDay: ( NSArray * _Nullable)arrayOfLevels withNum: (NSNumber * _Nullable)dayNum withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
