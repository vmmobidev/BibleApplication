//
//  SearchViewController.h
//  Bilbe application
//
//  Created by Rahul kumar on 11/20/13.
//  Copyright (c) 2013 Vmoksha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Verse.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)



@interface SearchViewController : UIViewController < UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate >
@property (weak, nonatomic) IBOutlet UITextField *textFieldForSearching;
@property (weak, nonatomic) IBOutlet UITextView *VOTDTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *autocompleteList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serachFieldTopConst;
@property (strong, nonatomic) Verse *verseOfTheDay;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewBottomConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *autocompleteHeightConst;

- (IBAction)searchTheQuery:(id)sender;
- (IBAction)returnKeyPressed:(UITextField *)sender;
- (IBAction)resignKeyboard:(id)sender;
@end
