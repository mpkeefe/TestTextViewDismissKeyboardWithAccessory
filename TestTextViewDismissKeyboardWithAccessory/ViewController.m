//
//  ViewController.m
//  TestTextViewDismissKeyboardWithAccessory
//
//  Created by Keefe, Mark on 8/7/15.
//  Copyright (c) 2015 Keefe, Mark. All rights reserved.
//

#import "ViewController.h"
#import "NYTTextSearchView.h"
#import "NYTArticleTextSearch.h"
#import "UITextView+NYTAdditions.h"

CGFloat const NYTiPhoneViewPadding = 16.0;

static NSString * const NYTArticleViewControllerSearchResultsSummaryTemplate = @"%lu of %lu";

static NSString * const TestText = @"Apple offers a number of resources where you can get Xcode development support: http://developer.apple.com: The Apple Developer website is the best source for up-to-date technical"
@"documentation on Xcode, iOS, and OS X."
@"http://developer.apple.com/xcode: The Xcode home page on the Apple Developer website provides information about acquiring the latest version of Xcode."
@"http://devforums.apple.com: The Apple Developer Forums are a good place to interact with fellow developers and Apple engineers, in a moderated web forum that also offers email notifications. The Developer Forums also feature a dedicated topic for Xcode developer previews."
@"Use http://bugreport.apple.com to report issues to Apple. Include detailed information of the issue, including the system and developer tools version information, and any relevant crash logs or console messages."
@"documentation on Xcode, iOS, and OS X."
@"http://developer.apple.com/xcode: The Xcode home page on the Apple Developer website provides information about acquiring the latest version of Xcode."
@"http://devforums.apple.com: The Apple Developer Forums are a good place to interact with fellow developers and Apple engineers, in a moderated web forum that also offers email notifications. The Developer Forums also feature a dedicated topic for Xcode developer previews."
@"Use http://bugreport.apple.com to report issues to Apple. Include detailed information of the issue, including the system and developer tools version information, and any relevant crash logs or console messages."
@"documentation on Xcode, iOS, and OS X."
@"http://developer.apple.com/xcode: The Xcode home page on the Apple Developer website provides information about acquiring the latest version of Xcode."
@"http://devforums.apple.com: The Apple Developer Forums are a good place to interact with fellow developers and Apple engineers, in a moderated web forum that also offers email notifications. The Developer Forums also feature a dedicated topic for Xcode developer previews."
@"Use http://bugreport.apple.com to report issues to Apple. Include detailed information of the issue, including the system and developer tools version information, and any relevant crash logs or console messages."
@"documentation on Xcode, iOS, and OS X."
@"http://developer.apple.com/xcode: The Xcode home page on the Apple Developer website provides information about acquiring the latest version of Xcode."
@"http://devforums.apple.com: The Apple Developer Forums are a good place to interact with fellow developers and Apple engineers, in a moderated web forum that also offers email notifications. The Developer Forums also feature a dedicated topic for Xcode developer previews."
@"Use http://bugreport.apple.com to report issues to Apple. Include detailed information of the issue, including the system and developer tools version information, and any relevant crash logs or console messages."
@"documentation on Xcode, iOS, and OS X."
@"http://developer.apple.com/xcode: The Xcode home page on the Apple Developer website provides information about acquiring the latest version of Xcode."
@"http://devforums.apple.com: The Apple Developer Forums are a good place to interact with fellow developers and Apple engineers, in a moderated web forum that also offers email notifications. The Developer Forums also feature a dedicated topic for Xcode developer previews."
@"Use http://bugreport.apple.com to report issues to Apple. Include detailed information of the issue, including the system and developer tools version information, and any relevant crash logs or console messages."
@"documentation on Xcode, iOS, and OS X."
@"http://developer.apple.com/xcode: The Xcode home page on the Apple Developer website provides information about acquiring the latest version of Xcode."
@"http://devforums.apple.com: The Apple Developer Forums are a good place to interact with fellow developers and Apple engineers, in a moderated web forum that also offers email notifications. The Developer Forums also feature a dedicated topic for Xcode developer previews."
@"Use http://bugreport.apple.com to report issues to Apple. Include detailed information of the issue, including the system and developer tools version information, and any relevant crash logs or console messages."
@"documentation on Xcode, iOS, and OS X."
@"http://developer.apple.com/xcode: The Xcode home page on the Apple Developer website provides information about acquiring the latest version of Xcode."
@"http://devforums.apple.com: The Apple Developer Forums are a good place to interact with fellow developers and Apple engineers, in a moderated web forum that also offers email notifications. The Developer Forums also feature a dedicated topic for Xcode developer previews."
@"Use http://bugreport.apple.com to report issues to Apple. Include detailed information of the issue, including the system and developer tools version information, and any relevant crash logs or console messages."
@"documentation on Xcode, iOS, and OS X."
@"http://developer.apple.com/xcode: The Xcode home page on the Apple Developer website provides information about acquiring the latest version of Xcode."
@"http://devforums.apple.com: The Apple Developer Forums are a good place to interact with fellow developers and Apple engineers, in a moderated web forum that also offers email notifications. The Developer Forums also feature a dedicated topic for Xcode developer previews."
@"END OF ARTICLE";

@interface ViewController () <NYTTextSearchViewDelegate, UITextViewDelegate>

@property (nonatomic) UITextView *textView;
@property (nonatomic) NYTArticleTextSearch *articleTextSearch;
@property (nonatomic) NYTTextSearchView *textSearchView;
@property (nonatomic) NSUInteger selectedTextSearchRangeIndex;
@property (nonatomic, getter=isTextSearchInProgress) BOOL textSearchInProgress;
@property (nonatomic) CGSize keyboardSize;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setup];
    
    
    // Setup "Find" action when selecting text to share as a quote.
    UIMenuItem *findMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Find All", @"Menu item for sharing the selected text as a quote") action:@selector(findAllSelectedText:)];
    
    [[UIMenuController sharedMenuController] setMenuItems:@[findMenuItem]];
    
    [self observeKeyboard];
}

- (void)setup {
    CGRect textViewFrame = CGRectMake(0.0, 0.0, CGRectGetMaxX(self.view.bounds), CGRectGetMaxY(self.view.bounds));
    
    self.textView = [[UITextView alloc] initWithFrame:textViewFrame];
    
    self.textView.text = TestText;

    self.textView.inputAccessoryView = self.textSearchView;
    
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.textView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.textView.alwaysBounceVertical = YES;
    self.textView.accessibilityTraits = UIAccessibilityTraitStaticText;
    self.textView.editable = NO;
    self.textView.delegate = self;
//    self.textView.longPressURLDelegate = self;
    
    // Text does not line up properly with the header text, even though they both use the same padding.
    CGFloat bodyIndent = 5.0;
    self.textView.textContainerInset = UIEdgeInsetsMake(self.textView.textContainerInset.top, NYTiPhoneViewPadding - bodyIndent, self.textView.textContainerInset.bottom, NYTiPhoneViewPadding - bodyIndent);
    [self.view addSubview:self.textView];
    [self.textView setNeedsLayout];
}

#pragma mark - Text Search

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(findAllSelectedText:) && self.textView.selectedRange.length) {
        return YES;
    }
    return NO;
}

- (NYTTextSearchView *)textSearchView {
    if (!_textSearchView) {
        _textSearchView = [[NSBundle mainBundle] loadNibNamed:@"NYTTextSearchView" owner:self options:nil].firstObject;
        _textSearchView.delegate = self;
        
        CGRect bounds = self.view.bounds;
        _textSearchView.frame = CGRectMake(CGRectGetMinX(bounds), 64.0, CGRectGetWidth(bounds), 64.0);
        _textSearchView.alpha = 0.0;
    }
    
    return _textSearchView;
}

- (void)scrollToSelectedTextSearchMatch {
    if (self.selectedTextSearchRangeIndex < self.articleTextSearch.numberOfMatches) {
        NSRange selectedTextSearchRange = ((NSValue *)self.articleTextSearch.matchingRanges[self.selectedTextSearchRangeIndex]).rangeValue;
        [self.textView scrollRangeToVisible:selectedTextSearchRange respectInsets:YES animated:YES];
    }
}

- (void)highlightTextSearchMatches {
    NSMutableAttributedString *mutableBodyAttributedString = [self.textView.attributedText mutableCopy];
    
    [self.articleTextSearch.matchingRanges enumerateObjectsUsingBlock:^(NSValue *rangeValueObject, NSUInteger index, BOOL *stop) {
        [mutableBodyAttributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:rangeValueObject.rangeValue];
        if (index == self.selectedTextSearchRangeIndex) {
            [mutableBodyAttributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor cyanColor] range:rangeValueObject.rangeValue];
        }
    }];
    
    self.textView.attributedText = [mutableBodyAttributedString copy];
}

- (void)unhighlightSearchMatches {
    NSMutableAttributedString *mutableBodyAttributedString = [self.textView.attributedText mutableCopy];
    
    [self.articleTextSearch.matchingRanges enumerateObjectsUsingBlock:^(NSValue *rangeValueObject, NSUInteger index, BOOL *stop) {
        [mutableBodyAttributedString removeAttribute:NSBackgroundColorAttributeName range:rangeValueObject.rangeValue];
    }];
    
    self.textView.attributedText = [mutableBodyAttributedString copy];
}

- (void)showTextSearchView {
    CGFloat targetYPosition = 0.0;
    CGRect newFrame = CGRectMake(CGRectGetMinX(self.textSearchView.frame), targetYPosition, CGRectGetWidth(self.textSearchView.frame), CGRectGetHeight(self.textSearchView.frame));
    
    [UIView animateWithDuration:1.5 delay:0.25 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.textSearchView.alpha = 1.0;
        self.textSearchView.frame = newFrame;
    } completion:nil];
}

- (void)hideTextSearchView {
    CGFloat targetYPosition = CGRectGetHeight(self.textSearchView.frame);
    CGRect newFrame = CGRectMake(CGRectGetMinX(self.textSearchView.frame), targetYPosition, CGRectGetWidth(self.textSearchView.frame), CGRectGetHeight(self.textSearchView.frame));
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.textSearchView.alpha = 0.0;
        self.textSearchView.frame = newFrame;
    } completion:^(BOOL finished) {
        UIEdgeInsets textSearchInsets = UIEdgeInsetsMake(64.0, 0.0, 0.0, 0.0);
        self.textView.contentInset = textSearchInsets;
        self.textView.scrollIndicatorInsets = textSearchInsets;
    }];
}

#pragma mark - Find Text

- (NYTArticleTextSearch *)articleTextSearch {
    if (!_articleTextSearch) {
        _articleTextSearch = [[NYTArticleTextSearch alloc] initWithSearchText:self.textView.text];
    }
    
    return _articleTextSearch;
}

- (void)findAllSelectedText:(id)sender {
    NSString *textToFind = [self.textView.text substringWithRange:self.textView.selectedRange];
    self.textSearchView.textSearchBar.text = textToFind;
    
    [self findText:textToFind];
}

- (void)findText:(NSString *)textToFind {
    self.textSearchInProgress = YES;
    
    if (self.articleTextSearch.numberOfMatches) {
        [self unhighlightSearchMatches];
    }
    
    [self searchTextString:self.textView.text forMatchingText:textToFind];
    
    if (self.articleTextSearch.numberOfMatches) {
        [self highlightTextSearchMatches];
    }
    
    UIEdgeInsets textSearchInsets = UIEdgeInsetsMake(64.0, 0.0, self.keyboardSize.height, 0.0);
    self.textView.contentInset = textSearchInsets;
    self.textView.scrollIndicatorInsets = textSearchInsets;
    
    [self scrollToSelectedTextSearchMatch];
    
    [self showTextSearchView];
}

- (void)searchTextString:(NSString *)textToSearch forMatchingText:(NSString *)textToFind {
    
    [self.articleTextSearch matchText:textToFind];
    
    self.selectedTextSearchRangeIndex = (self.textView.selectedRange.length) ? [self.articleTextSearch indexOfRange:self.textView.selectedRange] : 0;
    
    NSUInteger numberOfMatches = self.articleTextSearch.numberOfMatches;
    if (self.selectedTextSearchRangeIndex < numberOfMatches) {
        NSString *matchResultString = (self.articleTextSearch.numberOfMatches == 1) ? @"1 match" : [NSString stringWithFormat:NYTArticleViewControllerSearchResultsSummaryTemplate, self.selectedTextSearchRangeIndex + 1, numberOfMatches];
        
        self.textSearchView.searchResultSummaryLabel.text = matchResultString;
    }
    else {
        self.textSearchView.searchResultSummaryLabel.text = @"No matches";
        self.selectedTextSearchRangeIndex = 0;
    }
}

#pragma mark - NYTTextSearchViewDelegate

- (void)doneSearchingForText {
    self.textSearchInProgress = NO;
    
    [self unhighlightSearchMatches];
    [self hideTextSearchView];
}

- (void)didRequestPreviousMatch {
    if (self.selectedTextSearchRangeIndex > 0) {
        self.selectedTextSearchRangeIndex--;
        self.textSearchView.searchResultSummaryLabel.text = [NSString stringWithFormat:NYTArticleViewControllerSearchResultsSummaryTemplate, self.selectedTextSearchRangeIndex + 1, self.articleTextSearch.numberOfMatches];
    }
    
    [self highlightTextSearchMatches];
    [self scrollToSelectedTextSearchMatch];
}

- (void)didRequestNextMatch {
    if (self.selectedTextSearchRangeIndex < self.articleTextSearch.numberOfMatches - 1) {
        self.selectedTextSearchRangeIndex++;
        self.textSearchView.searchResultSummaryLabel.text = [NSString stringWithFormat:NYTArticleViewControllerSearchResultsSummaryTemplate, self.selectedTextSearchRangeIndex + 1, self.articleTextSearch.numberOfMatches];
    }
    
    [self highlightTextSearchMatches];
    [self scrollToSelectedTextSearchMatch];
}

- (void)didRequestNewSearchWithText:(NSString *)textSearchString {
    [self findText:textSearchString];
}

#pragma mark - Text Search Keyboard and UIMenuController Handling

- (void)observeKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    
    self.keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if (self.textSearchInProgress) {
        UIEdgeInsets textSearchInsets = UIEdgeInsetsMake(64.0, 0.0, self.keyboardSize.height, 0.0);
        self.textView.contentInset = textSearchInsets;
        self.textView.scrollIndicatorInsets = textSearchInsets;
        [self scrollToSelectedTextSearchMatch];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets textSearchInsets = UIEdgeInsetsMake(64.0, 0.0, 0.0, 0.0);
    self.textView.contentInset = textSearchInsets;
    self.textView.scrollIndicatorInsets = textSearchInsets;
}

@end
