//
//  SearchManager.h
//  Quest For Bible Verses
//
//  Created by Rahul kumar on 1/22/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import <Foundation/Foundation.h>
#define RETURNVALUEKEY @"returnValue"
#define STRINGTOBESENT @"stringToBeSent"

@protocol SearchManagerDelegate <NSObject>

- (void)managerResultString:(NSString *)result returnValue:(BOOL)returnValue andOccuranceOfString:(BOOL)occurance;

@end

@interface SearchManager : NSObject

@property (strong, nonatomic) NSArray *arrayOfKeyWords;
@property (weak, nonatomic) id <SearchManagerDelegate> delegate;


- (id)initWithArray:(NSArray *)arrayOfKeys;

- (NSDictionary *)searchResultsForString:(NSString *)string;
- (BOOL)occuranceOfString:(NSString *)string;
@end

