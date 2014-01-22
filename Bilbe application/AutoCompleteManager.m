//
//  AutoCompleteManager.m
//  Quest For Bible Verses
//
//  Created by Rahul kumar on 1/22/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "AutoCompleteManager.h"
#import "DatabaseManager.h"

@implementation AutoCompleteManager


- (NSMutableArray *)autoCompleteArray
{
    if (!_autoCompleteArray) {
        _autoCompleteArray = [[NSMutableArray alloc] init];
    }
    return _autoCompleteArray;
}

- (NSArray *)arrayOfKeywords
{
    if (!_arrayOfKeywords)
    {
        _arrayOfKeywords = [[DatabaseManager sharedInstance] getTheKeyWordsFromDatabase];
    }
    return _arrayOfKeywords;
}

- (NSMutableArray *)searchAutocompleteEntriesWithSubstring:(NSString *)substring
{
    [self.autoCompleteArray removeAllObjects];
    
    NSMutableArray *arryForFirstList = [[NSMutableArray alloc] init];
    NSMutableArray *arrayOfSecondList = [[NSMutableArray alloc] init];
    
    UIFont *fontForRangeOfSubstring;
    UIFont *fontForStringExecptSubstring;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        fontForRangeOfSubstring = [UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:20];
        fontForStringExecptSubstring = [UIFont fontWithName:@"Baskerville-Italic" size:20];
    }else
    {
        fontForRangeOfSubstring = [UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:18];
        fontForStringExecptSubstring = [UIFont fontWithName:@"Baskerville-Italic" size:18];
    }

    for (NSMutableAttributedString *currentAttributedString in self.arrayOfKeywords)
    {
        NSString *currentString = [currentAttributedString string];
        
        NSRange rangeOfCurrentString;
        rangeOfCurrentString.location = 0;
        rangeOfCurrentString.length = [currentString length];
        
        [currentAttributedString addAttribute:UITextAttributeFont value:fontForStringExecptSubstring range:rangeOfCurrentString];
        
        NSRange substringRange = [currentString rangeOfString:substring options:NSCaseInsensitiveSearch];
        
        if ( substringRange.location == 0)
        {
            [currentAttributedString addAttribute:UITextAttributeFont value:fontForRangeOfSubstring range:substringRange];
            //                [currentAttributedString setAttributes:@{UITextAttributeFont: fontForRangeOfSubstring} range:substringRange];
            [arryForFirstList addObject:currentAttributedString];
        } else if ( substringRange.location != NSNotFound & substringRange.location != 0)
        {
            [currentAttributedString addAttribute:UITextAttributeFont value:fontForRangeOfSubstring range:substringRange];
            [arrayOfSecondList addObject:currentAttributedString];
        }
    }

    [arryForFirstList addObjectsFromArray:arrayOfSecondList];
    if ([arryForFirstList count] != 0)
    {
        self.autoCompleteArray = arryForFirstList;
    } else
    {
        NSMutableAttributedString *noResultAttributedString =[[NSMutableAttributedString alloc] initWithString:@"No results found..."];
        self.autoCompleteArray = [@[noResultAttributedString] mutableCopy];
    }
    
    return self.autoCompleteArray;
}

- (CGFloat)heightOfTableForArrayCount:(int)count andRowHeight:(CGFloat)height
{
    int maxNumberOfCell;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if ([UIScreen mainScreen].bounds.size.height == 568)
            maxNumberOfCell = 6;
        else
            maxNumberOfCell = 5;
    } else  maxNumberOfCell = 7;
    
    CGFloat heigtOfTableView;
    
    if (count < maxNumberOfCell)
    {
        heigtOfTableView = height * count;
        
    } else
    {
        heigtOfTableView = height * maxNumberOfCell;
    }
    
    return heigtOfTableView;
}
@end
