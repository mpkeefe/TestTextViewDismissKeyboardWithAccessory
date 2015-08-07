//
//  NYTTextSearchView.m
//  NYTNewsReader
//
//  Created by Keefe, Mark on 7/23/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

#import "NYTTextSearchView.h"

@interface NYTTextSearchView () <UISearchBarDelegate>

@end

@implementation NYTTextSearchView

- (void)awakeFromNib {
    self.tintColor = [UIColor blueColor];
    self.doneButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    self.searchResultSummaryLabel.font = [UIFont systemFontOfSize:14.0];
    self.searchResultSummaryLabel.textColor = [UIColor lightTextColor];
}

#pragma mark - Actions

- (IBAction)previousButtonTapped:(UIButton *)sender {
    [self.delegate didRequestPreviousMatch];
}

- (IBAction)nextButtonTapped:(UIButton *)sender {
    [self.delegate didRequestNextMatch];
}

- (IBAction)doneButtonTapped:(UIButton *)sender {
    [self.delegate doneSearchingForText];
    [self.textSearchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.delegate didRequestNewSearchWithText:self.textSearchBar.text];
}

@end
