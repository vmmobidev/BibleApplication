//
//  AutoCompleteManager.h
//  Quest For Bible Verses
//
//  Created by Rahul kumar on 1/22/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutoCompleteManager : NSObject
@property (strong, nonatomic)NSMutableArray *autoCompleteArray;
@property (strong, nonatomic)NSArray *arrayOfKeywords;

- (NSMutableArray *)searchAutocompleteEntriesWithSubstring:(NSString *)substring;
- (CGFloat)heightOfTableForArrayCount:(int)count andRowHeight:(CGFloat)height;

@end
