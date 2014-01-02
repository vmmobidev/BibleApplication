//
//  DatabaseManager.h
//  Bilbe application
//
//  Created by Rahul kumar on 12/31/13.
//  Copyright (c) 2013 Vmoksha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseManager : NSObject

@property (strong, nonatomic) NSArray *keyWords;

- (NSArray *)getTheKeyWordsFromDatabase;
@end
