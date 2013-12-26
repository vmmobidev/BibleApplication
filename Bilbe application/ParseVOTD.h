//
//  ParseVOTD.h
//  Bilbe application
//
//  Created by Rahul kumar on 12/26/13.
//  Copyright (c) 2013 Vmoksha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseVOTD : NSObject < NSXMLParserDelegate >

- (NSDictionary *)getVOTDForData:(NSData *)data;

@end
