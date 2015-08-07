//
//  UITextView+NYTAdditions.m
//  NYTiPhoneReader
//
//  Created by Bruneau, Paul on 9/18/13.
//  Copyright (c) 2013 The New York Times Company. All rights reserved.
//

#import "UITextView+NYTAdditions.h"

@implementation UITextView (NYTAdditions)

- (NSUInteger)glyphIndexAtTopOfTextView {
    CGPoint topOfViewPoint = CGPointMake(0, self.contentOffset.y - self.textContainerInset.top);
    
    if (topOfViewPoint.y > 0.0) {
        return [self.layoutManager glyphIndexForPoint:topOfViewPoint inTextContainer:self.textContainer];
    }
    
    return 0; // The closest glyph was below the top of the view (indicating the text view is scrolled to top).
}

- (NSUInteger)glyphIndexAtBottomOfTextView {
    CGPoint bottomOfViewPoint = CGPointMake(0, self.contentOffset.y + self.contentSize.height);
    return [self.layoutManager glyphIndexForPoint:bottomOfViewPoint inTextContainer:self.textContainer];
}

- (void)scrollToGlyphAtIndex:(NSUInteger)glyphIndex animated:(BOOL)animated {
    if (glyphIndex > 0) {
        [self setContentOffset:[self contentOffsetForGlyphAtIndex:glyphIndex] animated:animated];
    }
}

- (CGPoint)contentOffsetForGlyphAtIndex:(NSUInteger)glyphIndex {
    CGFloat glyphY = 0.0; // Default to no offset (the text view is scrolled to top).
    if (glyphIndex) {
        glyphY = CGRectGetMinY([self.layoutManager lineFragmentUsedRectForGlyphAtIndex:glyphIndex effectiveRange:NULL]);
        glyphY += self.textContainerInset.top;
    }
    
    CGPoint contentOffset = self.contentOffset;
    
    CGFloat maxContentOffset = self.contentSize.height - CGRectGetHeight(self.bounds) + self.contentInset.bottom;
    
    contentOffset.y = MIN(maxContentOffset, glyphY);
    
    return contentOffset;
}

- (void)scrollRangeToVisible:(NSRange)range respectInsets:(BOOL)respectInsets animated:(BOOL)animated {
    if (respectInsets && (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)) {
        // Calculate rect for range
        UITextPosition *startPosition = [self positionFromPosition:self.beginningOfDocument offset:range.location];
        UITextPosition *endPosition = [self positionFromPosition:startPosition offset:range.length];
        UITextRange *textRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
        CGRect rect = [self firstRectForRange:textRange];
        
        // Scrolls to visible rect
        [self scrollRectToVisible:rect respectInsets:YES animated:animated];
    }
    else {
        [self scrollRangeToVisible:range];
    }
}

- (void)scrollRectToVisible:(CGRect)rect respectInsets:(BOOL)respectInsets animated:(BOOL)animated {
    if (respectInsets && (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)) {
        // Gets bounds and calculates visible rect
        CGRect bounds = self.bounds;
        UIEdgeInsets contentInset = self.contentInset;
        CGRect visibleRect = [self visibleRectRespectingInsets:YES];
        
        // Do not scroll if rect is on screen
        if (!CGRectContainsRect(visibleRect, rect)) {
            CGPoint contentOffset = self.contentOffset;
            // Calculate new contentOffset
            if (rect.origin.y < visibleRect.origin.y) {
                // rect precedes bounds, scroll up
                contentOffset.y = rect.origin.y - contentInset.top;
            }
            else {
                // rect follows bounds, scroll down
                contentOffset.y = rect.origin.y + contentInset.bottom + rect.size.height - bounds.size.height;
            }
            
            [self setContentOffset:contentOffset animated:animated];
        }
    }
    else {
        [self scrollRectToVisible:rect animated:animated];
    }
}

- (CGRect)visibleRectRespectingInsets:(BOOL)respectInsets {
    if (!respectInsets) {
        return self.bounds;
    }
    
    CGRect visibleRect = self.bounds;
    UIEdgeInsets contentInset = self.contentInset;
    visibleRect.origin.x += contentInset.left;
    visibleRect.origin.y += contentInset.top;
    visibleRect.size.width -= (contentInset.left + contentInset.right);
    visibleRect.size.height -= (contentInset.top + contentInset.bottom);

    return visibleRect;
}

@end
