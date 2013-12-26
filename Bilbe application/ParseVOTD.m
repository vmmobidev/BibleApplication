//
//  ParseVOTD.m
//  Bilbe application
//
//  Created by Rahul kumar on 12/26/13.
//  Copyright (c) 2013 Vmoksha. All rights reserved.
//

#import "ParseVOTD.h"
#import "AFNetworking.h"

@implementation ParseVOTD
{
    NSMutableString *verse;
    NSString *currentElement, *chapters;
    BOOL stopAppending;
}

- (NSDictionary *)getVOTDForData:(NSData *)data
{
    verse = [[NSMutableString alloc] init];
    currentElement = [[NSString alloc] init];
    stopAppending = YES;
    NSDictionary *dictionayForReturing;
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    
        parser.delegate = self;
    if ([parser parse]){
            NSLog(@"Success");
            dictionayForReturing = @{@"chapter":chapters, @"verse":verse};

    }else
            NSLog(@"failure");
    
    return dictionayForReturing;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    currentElement = elementName;
    if ([elementName isEqualToString:@"text"])
    {
        stopAppending = NO;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([currentElement isEqualToString:@"title"])
    {
        if (!chapters)
        {
            chapters = [[NSString alloc] init];
        }
        chapters = string;
    }
    
    if (!stopAppending)
    {
        [verse appendString:string];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"text"])
    {
        stopAppending = YES;
    }
}

@end
