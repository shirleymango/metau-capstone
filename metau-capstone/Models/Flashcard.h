//
//  Flashcard.h
//  metau-capstone
//
//  Created by Shirley Zhu on 7/11/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Flashcard : PFObject <PFSubclassing>
@property (nonatomic, strong) NSString *frontText;
@property (nonatomic, strong) NSString *backText;
@property (nonatomic, strong) NSNumber *levelNum;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic) BOOL toBeReviewed;

+ (void) createCard: ( NSString * _Nullable)frontText withBack: (NSString * _Nullable)backText withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (void) createCardsFromDictionary: (NSDictionary *) dictionary;

@end

NS_ASSUME_NONNULL_END
