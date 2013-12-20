//
//  ParserOfHTML.h
//  Bilbe application
//
//  Created by Rahul kumar on 12/16/13.
//  Copyright (c) 2013 Vmoksha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParserOfHTML : NSObject < NSXMLParserDelegate >

@property (strong, nonatomic) NSMutableArray *arrayOfVerses, *arrayOfChapter;

- (NSDictionary *)parseHTMLstring:(NSString *)string;

@end
