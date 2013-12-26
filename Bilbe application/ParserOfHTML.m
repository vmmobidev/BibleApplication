//
//  ParserOfHTML.m
//  Bilbe application
//
//  Created by Rahul kumar on 12/16/13.
//  Copyright (c) 2013 Vmoksha. All rights reserved.
//

#import "ParserOfHTML.h"

@implementation ParserOfHTML
{
    NSString *stringForParsing, *currentElementOnParser;
    NSMutableString *stringForAppendingVerses;
//    NSMutableArray *arrayOfVerses, *arrayOfChapter;
}


- (NSMutableArray *)arrayOfChapter
{
    if (!_arrayOfChapter) {
        _arrayOfChapter = [[NSMutableArray alloc] init];
    }
    
    return _arrayOfChapter;
}

- (NSMutableArray *)arrayOfVerses
{
    if (!_arrayOfVerses)
    {
        _arrayOfVerses = [[NSMutableArray alloc] init];
    }
    
    return _arrayOfVerses;
}

- (NSDictionary *) parseHTMLstring:(NSMutableString *)string
{
    while (1)
    {
        // Finding <div class=\"verse\"> and delete contents before that.
        NSRange rangeOfFirstMatch = [string rangeOfString:@"<div class=\"verse\">"];
        
        if (rangeOfFirstMatch.location != NSNotFound)
        {
            NSRange rangeOfTextToDelete;
            rangeOfTextToDelete.location = 0;
            rangeOfTextToDelete.length = rangeOfFirstMatch.location;
            [string deleteCharactersInRange:rangeOfTextToDelete];
            
            
            // Search for </div> and copy contents into another string
            NSRange rangeOfSecondMatch = [string rangeOfString:@"</div>"];
            NSRange rangeOfContentForCoping;
            rangeOfContentForCoping.location = 0;
            rangeOfContentForCoping.length = rangeOfSecondMatch.location + rangeOfSecondMatch.length;
            
            stringForParsing = [string substringWithRange:rangeOfContentForCoping];
            [string deleteCharactersInRange:rangeOfContentForCoping];
            
            
            
            NSMutableString *stringgggggggg = [stringForParsing mutableCopy];
            
            while (1)
            {
                NSRange rangeForReplaceing = [stringgggggggg rangeOfString:@"<span class=\"sc\">Lord</span>"];
                
                if (rangeForReplaceing.location != NSNotFound)
                {
                    [stringgggggggg replaceCharactersInRange:rangeForReplaceing withString:@"Lord"];
                }else
                    break;
            }
            
            while (1)
            {
                NSRange rangeForReplaceing = [stringgggggggg rangeOfString:@"<span class=\"sc\">God</span>"];
                
                if (rangeForReplaceing.location != NSNotFound)
                {
                    [stringgggggggg replaceCharactersInRange:rangeForReplaceing withString:@"God"];
                }else
                    break;
            }
            
//            while (1)
//            {
//                NSRange rangeForRemoving = [stringgggggggg rangeOfString:@"&ldquo;"];
//                
//                if (rangeForRemoving.location != NSNotFound)
//                {
//                    [stringgggggggg deleteCharactersInRange:rangeForRemoving];
//                }else
//                    break;
//            }
//            
//            while (1)
//            {
//                NSRange rangeForRemoving = [stringgggggggg rangeOfString:@"&rdquo;"];
//                
//                if (rangeForRemoving.location != NSNotFound)
//                {
//                    [stringgggggggg deleteCharactersInRange:rangeForRemoving];
//                }else
//                    break;
//            }
//            
//            while (1)
//            {
//                NSRange rangeForRemoving = [stringgggggggg rangeOfString:@"&lsquo;"];
//                
//                if (rangeForRemoving.location != NSNotFound)
//                {
//                    [stringgggggggg deleteCharactersInRange:rangeForRemoving];
//                }else
//                    break;
//            }
//            
//            
//            while (1)
//            {
//                NSRange rangeForRemoving = [stringgggggggg rangeOfString:@"&rsquo;"];
//                
//                if (rangeForRemoving.location != NSNotFound)
//                {
//                    [stringgggggggg deleteCharactersInRange:rangeForRemoving];
//                }else
//                    break;
//            }
//            
//            
//            while (1)
//            {
//                NSRange rangeForRemoving = [stringgggggggg rangeOfString:@"&mdash;"];
//                
//                if (rangeForRemoving.location != NSNotFound)
//                {
//                    [stringgggggggg deleteCharactersInRange:rangeForRemoving];
//                }else
//                    break;
//            }
            
//            NSLog(@"%@", stringForParsing);
            
            // Parsing the string
            NSData *dataToBeParsed = [stringgggggggg dataUsingEncoding:NSUTF8StringEncoding];
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataToBeParsed];
            parser.delegate = self;
            
            stringForAppendingVerses = [[NSMutableString alloc] init];
            
            if ([parser parse])
            {
                //                NSLog(@"Parsing is ok");
            } else
                NSLog(@"Parsing is not ok");
        } else
            break;
        
    }
    
    NSLog(@"%i", [self.arrayOfVerses count]);
    
    NSLog(@"%@", self.arrayOfChapter);
    
    NSDictionary *dictionaryOfAllResults = @{@"verses": self.arrayOfVerses, @"chapters":self.arrayOfChapter};
    
    return dictionaryOfAllResults;
}


#pragma mark NSXMLParsing methods
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    currentElementOnParser = elementName;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([currentElementOnParser isEqualToString:@"a"])
    {
        NSString *stringToBeTested = string;
        
        if ([[stringToBeTested stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] != 0)
        {
            [self.arrayOfChapter addObject:string];
            
            //            NSLog(@"%@", string);
        }
    }
    if ([currentElementOnParser isEqualToString:@"p"])
    {
        NSString *stringToBeTested = string;
        
        if ([[stringToBeTested stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] != 0)
        {
            [stringForAppendingVerses appendString:string];
            
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([currentElementOnParser isEqualToString:@"p"] && [elementName isEqualToString:@"p"])
    {
        NSRange rangeOfWhitespace = [stringForAppendingVerses rangeOfCharacterFromSet:[NSCharacterSet alphanumericCharacterSet]];
        
        NSRange rangeForDeleting = NSMakeRange(0, rangeOfWhitespace.location - 1);
        
        [stringForAppendingVerses deleteCharactersInRange:rangeForDeleting];
        
        [self.arrayOfVerses addObject:stringForAppendingVerses];
    }
}

@end
