//
//  Schedule.m
//  metau-capstone
//
//  Created by Shirley Zhu on 7/12/22.
//

#import "Schedule.h"
#import "PFObject+Subclass.h"

@implementation Schedule
@dynamic arrayOfLevels;
@dynamic dayNum;

+ (nonnull NSString *)parseClassName {
    return @"Schedule";
}

+ (void) createDay: ( NSArray * _Nullable )arrayOfLevels withNum: ( NSNumber * _Nullable )dayNum withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Schedule *newSched = [Schedule new];
    newSched.arrayOfLevels = arrayOfLevels;
    newSched.dayNum = dayNum;
    
    [newSched saveInBackgroundWithBlock:completion];
}

@end
