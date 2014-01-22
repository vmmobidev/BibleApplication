//
//  SearchManager.m
//  Quest For Bible Verses
//
//  Created by Rahul kumar on 1/22/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "SearchManager.h"



@implementation SearchManager
{
    NSString *stringToBeSent;
    NSMutableDictionary *dictionaryOfResult;
}

- (id)initWithArray:(NSArray *)arrayOfKeys
{
    self = [super init];
    if (self)
    {
        self.arrayOfKeyWords = arrayOfKeys;
    }
    return self;
}

- (NSDictionary *)searchResultsForString:(NSString *)string
{
    NSMutableString *stringForTrimming = [string mutableCopy];
    
    BOOL returnValue;
    
    if (!stringToBeSent)
    {
        stringToBeSent = [[NSString alloc] init];
    }
    
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@" "];
    
    [characterSet formUnionWithCharacterSet:[NSCharacterSet alphanumericCharacterSet]];
    
    characterSet = [[characterSet invertedSet] mutableCopy];
    
    stringToBeSent = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    
    if ([stringForTrimming stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
        [self.delegate managerResultString:@"  Please ask somethig here..." returnValue:NO andOccuranceOfString:YES];
        returnValue = NO;
    }else if ([string isEqualToString:@"  Please ask somethig here..."] || [string isEqualToString:@"  Please ask something meaningful..."])
    {
        returnValue = NO;
    }else if (stringToBeSent.length == 0)
    {
        [self.delegate managerResultString:@"  Please ask something meaningful..." returnValue:NO andOccuranceOfString:YES];
        returnValue = NO;
    } else
    {
        BOOL occuranceOfStringInArray = NO;
        for (NSMutableAttributedString *attributedString in self.arrayOfKeyWords)
        {
            NSString *currentString = [attributedString string];
            
            if ([currentString compare:stringToBeSent options:NSCaseInsensitiveSearch] == NSOrderedSame)
            {
                occuranceOfStringInArray = YES;
                break;
            }
        }
        
        if (![self occuranceOfString:stringToBeSent])
        {
            [self.delegate managerResultString:Nil returnValue:NO andOccuranceOfString:NO];
            returnValue = NO;
        }else
        {
            returnValue = YES;
        }
    }
    return @{RETURNVALUEKEY:[NSNumber numberWithBool:returnValue], STRINGTOBESENT:stringToBeSent };
}

- (BOOL)occuranceOfString:(NSString *)string
{
    BOOL occuranceOfStringInArray = NO;
    for (NSMutableAttributedString *attributedString in self.arrayOfKeyWords)
    {
        NSString *currentString = [attributedString string];
        
        if ([currentString compare:string options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            occuranceOfStringInArray = YES;
            break;
        }
    }
    return occuranceOfStringInArray;
}

@end
