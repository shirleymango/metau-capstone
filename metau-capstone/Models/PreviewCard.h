//
//  PreviewCard.h
//  metau-capstone
//
//  Created by Shirley Zhu on 7/28/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreviewCard : PFObject <PFSubclassing>
@property (nonatomic, strong) NSString *frontText;
@property (nonatomic, strong) NSString *backText;
@property (nonatomic) BOOL isSelected;
@property (nonatomic, strong) NSString *userID;

+ (void) createPreviewCard: ( NSString * _Nullable )frontText withBack: ( NSString * _Nullable )backText;
+ (void) createCardsFromDictionary: (NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
