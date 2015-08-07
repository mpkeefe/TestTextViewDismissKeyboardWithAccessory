//
//  NYTTextSearchView.h
//  NYTNewsReader
//
//  Created by Keefe, Mark on 7/23/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NYTTextSearchViewDelegate;

@interface NYTTextSearchView : UIView

@property (nonatomic) IBOutlet UIView *containerView;
@property (nonatomic) IBOutlet UIButton *previousButton;
@property (nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic) IBOutlet UILabel *searchResultSummaryLabel;
@property (nonatomic) IBOutlet UISearchBar *textSearchBar;
@property (nonatomic) IBOutlet UIButton *doneButton;

@property (nonatomic, weak) id <NYTTextSearchViewDelegate> delegate;

@end

@protocol NYTTextSearchViewDelegate <NSObject>

- (void)doneSearchingForText;
- (void)didRequestPreviousMatch;
- (void)didRequestNextMatch;
- (void)didRequestNewSearchWithText:(NSString *)textSearchString;

@end
