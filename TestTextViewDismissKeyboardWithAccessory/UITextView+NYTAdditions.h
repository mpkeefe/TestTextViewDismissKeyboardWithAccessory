//
//  UITextView+NYTAdditions.h
//  NYTiPhoneReader
//
//  Created by Bruneau, Paul on 9/18/13.
//  Copyright (c) 2013 The New York Times Company. All rights reserved.
//

@import UIKit;

/**
 *  The UITextView+NYTAdditions category provides convenience methods for calculating and scrolling to glyph indexes.
 */
@interface UITextView (NYTAdditions)

/**
 *  // Scroll so range is just (completely) visible (nearest edges). Do nothing if range is already completely visible.
 */
- (void)scrollRangeToVisible:(NSRange)range respectInsets:(BOOL)respectInsets animated:(BOOL)animated;

@end
