//
//  TestTableViewController.h
//  Bilbe application
//
//  Created by Rahul kumar on 11/20/13.
//  Copyright (c) 2013 Vmoksha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface ResultsListedViewController : UITableViewController <NSXMLParserDelegate>

@property (strong, nonatomic) NSString *searchQuery;

@end
