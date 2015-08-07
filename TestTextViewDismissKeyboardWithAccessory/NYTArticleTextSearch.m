//
//  NYTArticleTextSearch.m
//  NYTNewsReader
//
//  Created by Mark Keefe on 8/2/15.
//  Copyright © 2015 NYTimes. All rights reserved.
//

#import "NYTArticleTextSearch.h"

@interface NYTArticleTextSearch ()

@property (nonatomic) NSString *textToSearch;
@property (nonatomic, copy, readwrite) NSArray *matchingRanges;

@end

@implementation NYTArticleTextSearch

- (nullable instancetype)initWithSearchText:(nullable NSString *)textToSearch {
    self = [super init];
    if (self) {
        _textToSearch = textToSearch;
    }
    return self;
}

- (nullable instancetype)init {
    return [self initWithSearchText:nil];
}

- (void)matchText:(NSString *)textToFind {
    NSMutableArray *foundRanges = [NSMutableArray array];
    
    NSUInteger count = 0, length = [self.textToSearch length];
    NSRange range = NSMakeRange(0, length);
    
    while (range.location != NSNotFound) {
        range = [self.textToSearch rangeOfString:textToFind options:NSCaseInsensitiveSearch range:range];
        if (range.location != NSNotFound) {
            [foundRanges addObject:[NSValue valueWithRange:range]];
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++;
        }
    }
    
    self.matchingRanges = [NSArray arrayWithArray:foundRanges];
}

- (NSUInteger)indexOfRange:(NSRange)textSearchRange {
    NSUInteger __block rangeIndex = NSNotFound;
    
    [self.matchingRanges enumerateObjectsUsingBlock:^(NSValue *rangeValueObject, NSUInteger index, BOOL *stop) {
        if (rangeValueObject.rangeValue.location == textSearchRange.location) {
            *stop = YES;
            rangeIndex = index;
        }
    }];
    
    return rangeIndex;
}

- (NSUInteger)numberOfMatches {
    return self.matchingRanges.count;
}

@end
