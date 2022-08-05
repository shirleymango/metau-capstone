//
//  PreviewManager.h
//  metau-capstone
//
//  Created by Shirley Zhu on 8/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreviewManager : NSObject

+ (instancetype)shared;
@property NSMutableArray *previewFlashcards;

@end

NS_ASSUME_NONNULL_END
