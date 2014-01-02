//
//  DatabaseManager.m
//  Bilbe application
//
//  Created by Rahul kumar on 12/31/13.
//  Copyright (c) 2013 Vmoksha. All rights reserved.
//

#import "DatabaseManager.h"

@implementation DatabaseManager
{
    sqlite3 *keywordsDB;
    NSString *dbPath;
}
- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (NSArray *)keyWords
{
    if (!_keyWords)
    {
        _keyWords = [[NSArray alloc] init];
    }
    
    return _keyWords;
}

- (NSArray *)getTheKeyWordsFromDatabase
{
    dbPath = [[NSBundle mainBundle] pathForResource:@"keywords" ofType:@"db"];
    NSMutableArray *mutableCollectionOfKeyWords = [[NSMutableArray alloc] init];
    
    if (sqlite3_open([dbPath UTF8String], &keywordsDB) == SQLITE_OK)
    {
        NSString *query = @"Select KeyWord FROM KEYWORDS";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(keywordsDB, [query UTF8String], -1, &statement, Nil) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *keyWord = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                [mutableCollectionOfKeyWords addObject:keyWord];
            }
            sqlite3_finalize(statement);
        }else
            NSLog(@"Failed preparetion");
        sqlite3_close(keywordsDB);
    }
    _keyWords = mutableCollectionOfKeyWords;
    
    NSLog(@"%i",mutableCollectionOfKeyWords.count);
    
    return mutableCollectionOfKeyWords;
}

@end
