//
//  PreviewManager.m
//  metau-capstone
//
//  Created by Shirley Zhu on 8/5/22.
//

#import "PreviewManager.h"

@implementation PreviewManager

+ (instancetype)shared {
    static PreviewManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype) init {
    self.previewFlashcards = [NSMutableArray new];
    return self;
}

@end
