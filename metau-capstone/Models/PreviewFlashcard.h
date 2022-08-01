//
//  PreviewFlashcard.h
//  metau-capstone
//
//  Created by Shirley Zhu on 7/29/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreviewFlashcard : NSObject
@property (nonatomic, strong) NSString *frontText;
@property (nonatomic, strong) NSString *backText;
@property (nonatomic) BOOL isSelected;

+ (PreviewFlashcard *) createPreviewCard: ( NSString * _Nullable )frontText withBack: ( NSString * _Nullable )backText;
+ (NSMutableArray *) createCardsFromDictionary: (NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
