//
//  NYTArticleTextSearch.h
//  NYTNewsReader
//
//  Created by Mark Keefe on 8/2/15.
//  Copyright © 2015 NYTimes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NYTArticleTextSearch : NSObject

@property (nonatomic, copy, readonly, nullable) NSArray *matchingRanges;

@property (nonatomic, readonly) NSUInteger numberOfMatches;

- (void)matchText:(NSString * __nonnull)textToFind;

- (NSUInteger)indexOfRange:(NSRange)textSearchRange;

- (nullable instancetype)initWithSearchText:(nullable NSString *)textToSearch NS_DESIGNATED_INITIALIZER;

@end
