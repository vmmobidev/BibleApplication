//
//  SearchViewController.m
//  Bilbe application
//
//  Created by Rahul kumar on 11/20/13.
//  Copyright (c) 2013 Vmoksha. All rights reserved.
//


#import "SearchViewController.h"
#import "TestAppDelegate.h"
#import "InfoViewController.h"
#import "ResultsListedViewController.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "ParseVOTD.h"
#import "DatabaseManager.h"
#import "Flurry.h"
#import "AutoCompleteManager.h"

#define URLForVOTD [NSURL URLWithString:@"http://labs.bible.org/api/?passage=votd&type=xml"]

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *serachButton;
@property (weak, nonatomic) IBOutlet UIView *warningMessageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warnigViewTopConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warnigViewHeightConst;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic, strong) UIPopoverController *popoverViewController;
@property (nonatomic, strong) SearchManager *searchManager;
@property (nonatomic, strong) AutoCompleteManager *autoCompleteManager;

@end

@implementation SearchViewController
{
    NSMutableString *votdChatpter;
    NSMutableString *votdVerse;
    NSString *stringToBeSent;
    UIFont *fontForTxtFldWhileEditing;
    NSMutableArray *autoCompleteArray;
    NSArray *arrayOfKeyWords;
    
    UIBarButtonItem *infoBarButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}

- (void)loadView
{
    [super loadView];

    UIButton *infoButton;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
         infoButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 25, 25))];
        [infoButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:(UIControlEventTouchUpInside)];
    } else
    {
        infoButton = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 30, 30))];
        [infoButton addTarget:self action:@selector(infoButtonForIpadPressed:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    [infoButton setImage:[UIImage imageNamed:@"Info-icon.png"] forState:(UIControlStateNormal)];
    
    infoBarButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    self.navigationItem.rightBarButtonItem = infoBarButton;
}

- (void)infoButtonPressed:(UIButton *)sender
{
//    TestAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    InfoViewController *infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoViewController"];
    
    [self presentViewController:infoController animated:YES completion:Nil];
}

- (void)infoButtonForIpadPressed:(UIButton *)sender
{
    InfoViewController *infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoViewController"];
    
    if (!_popoverViewController)
    {
        _popoverViewController = [[UIPopoverController alloc] initWithContentViewController:infoController];
    }
    if (_popoverViewController.isPopoverVisible)
    {
        [_popoverViewController dismissPopoverAnimated:YES];
    }else
        [_popoverViewController presentPopoverFromBarButtonItem:infoBarButton permittedArrowDirections:(UIPopoverArrowDirectionUp) animated:YES];

  

}

- (AutoCompleteManager *)autoCompleteManager
{
    if (!_autoCompleteManager)
    {
        _autoCompleteManager = [[AutoCompleteManager alloc] init];
    }
    return _autoCompleteManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"Animation");
    
    _imageView.animationImages = @[[UIImage imageNamed:@"1.1.png"],[UIImage imageNamed:@"1.2.png"],[UIImage imageNamed:@"2.png"],[UIImage imageNamed:@"3.1.png"],[UIImage imageNamed:@"3.2.png"],[UIImage imageNamed:@"4.1.png"],[UIImage imageNamed:@"4.2.png"],[UIImage imageNamed:@"5.1.png"],[UIImage imageNamed:@"5.2.png"],[UIImage imageNamed:@"6.png"],[UIImage imageNamed:@"7.1.png"],[UIImage imageNamed:@"7.2.png"],[UIImage imageNamed:@"8.png"],[UIImage imageNamed:@"9.1.png"],[UIImage imageNamed:@"9.2.png"],[UIImage imageNamed:@"10.png"],[UIImage imageNamed:@"11.png"],[UIImage imageNamed:@"12.png"],[UIImage imageNamed:@"13.1.png"],[UIImage imageNamed:@"13.2.png"],[UIImage imageNamed:@"14.1.png"],[UIImage imageNamed:@"14.2.png"],[UIImage imageNamed:@"15.png"]];
    
    _imageView.animationDuration = .8;
    _imageView.animationRepeatCount = 1;
    
    [_imageView startAnimating];

    fontForTxtFldWhileEditing = _textFieldForSearching.font;
    _textFieldForSearching.delegate = self;
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        _serachButton.titleLabel.font = [UIFont fontWithName:@"JamesFajardo" size:30];

    } else
        _serachButton.titleLabel.font = [UIFont fontWithName:@"JamesFajardo" size:26];

    _serachButton.titleLabel.textColor = [UIColor colorWithRed:222/255 green:204/255 blue:126/255 alpha:1];
    _serachButton.titleLabel.shadowColor = [UIColor blackColor];
    
    _serachButton.titleLabel.shadowOffset = CGSizeMake(2, 3);
    
//    [_serachButton setBackgroundImage:[UIImage imageNamed:@"searchButton.png"] forState:UIControlStateNormal];
    
    _textFieldForSearching.layer.shadowColor = [UIColor blackColor].CGColor;
    _textFieldForSearching.layer.shadowOffset = CGSizeMake(2, 2);
    _textFieldForSearching.layer.shadowOpacity = .8;
    _textFieldForSearching.layer.shadowRadius = 5.0;
    _textFieldForSearching.layer.masksToBounds = NO;
    


    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if ([UIScreen mainScreen].bounds.size.height == 568)
        {
            _serachFieldTopConst.constant=120;
            _imageViewBottomConst.constant = -330;
        }
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        {
            _serachFieldTopConst.constant = 20.0f;
            _warnigViewTopConst.constant = 0.0f;
//            _warnigViewHeightConst.constant = 45;

        } else
        {
            _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
            _imageView.layer.shadowOffset = CGSizeMake(3, 3);
            _imageView.layer.shadowOpacity = .8;
            _imageView.layer.shadowRadius = 3.0;
            _imageView.layer.masksToBounds = NO;
        }
    }
    
    
    _activityIndicator.hidden = YES;
    
//    NSTimer *delayForVOTD = [NSTimer scheduledTimerWithTimeInterval:.8 target:self selector:@selector(getVOTDFromAPI) userInfo:Nil repeats:NO];
    
    self.title = @"Quest For Bible Verses";
    
//    self.navigationController.navigationItem.titleView
    
//    self.textFieldForSearching.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"textfield.png"]];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    
    NSString *remoteHostName = @"www.google.com";

    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
	[self.hostReachability startNotifier];
    
//    DatabaseManager *databaseManager = [[DatabaseManager alloc] init];
//    arrayOfKeyWords = [databaseManager getTheKeyWordsFromDatabase];
    
    arrayOfKeyWords = [[DatabaseManager sharedInstance] getTheKeyWordsFromDatabase];
    NSLog(@"array of keywords = %i", arrayOfKeyWords.count);
    
    autoCompleteArray = [[NSMutableArray alloc] init];
    
}

- (SearchManager *)searchManager
{
    if(!_searchManager)
    {
        _searchManager = [[SearchManager alloc] initWithArray:arrayOfKeyWords];
        _searchManager.delegate = self;
    }
    return _searchManager;
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    Reachability *reach = [notification object];
    NetworkStatus status = [reach currentReachabilityStatus];
    
    if (status == NotReachable)
    {
        UIAlertView *alertForNoNetwork = [[UIAlertView alloc] initWithTitle:@"No Internet Connectivity"  message:@"There is no internet connectvity. Please connect to internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertForNoNetwork show];
    } else
    {
//        [self getVOTDFromAPI];
        NSTimer *delayForVOTD ;
        delayForVOTD = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(getVOTDFromAPI) userInfo:Nil repeats:NO];
    }
    

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _imageView.animationImages = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    _activityIndicator.hidden = YES;

//    for (NSString *family in [UIFont familyNames])
//    {
//        for (NSString *names in [UIFont fontNamesForFamilyName:family])
//        {
//            NSLog(@"%@ %@", family, names);
//        }
//    }
    
    _warningMessageView.alpha = 0.0f;
    _warningMessageView.hidden = YES;

}

- (void)getVOTDFromAPI
{
    NSLog(@"VOTD");
    _verseOfTheDay = [[Verse alloc] init];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URLForVOTD];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = (NSData *)responseObject;
        
        ParseVOTD *parserForVODT = [[ParseVOTD alloc] init];
        NSDictionary *dictionaryOfVerse = [parserForVODT getVOTDForData:data];
        
        _verseOfTheDay.chapter = dictionaryOfVerse[@"chapter"];
        _verseOfTheDay.verse = dictionaryOfVerse[@"verse"];
        
        _activityIndicator.hidden = YES;
        UIFont *fontForChapters;
        UIFont *fontForVerses;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            fontForChapters = [UIFont fontWithName:@"JamesFajardo" size:33];
            fontForVerses =[UIFont fontWithName:@"Desyrel" size:17.0];
        } else
        {
            fontForChapters = [UIFont fontWithName:@"JamesFajardo" size:50];
            fontForVerses =[UIFont fontWithName:@"Desyrel" size:29];
        }
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 3.0f;
        paragraph.alignment = NSTextAlignmentCenter;
        
        NSMutableAttributedString *attributeStrForChapters = [[NSMutableAttributedString alloc] initWithString:self.verseOfTheDay.chapter attributes:@{NSFontAttributeName:fontForChapters,NSParagraphStyleAttributeName:paragraph, NSForegroundColorAttributeName: [UIColor redColor]}];
        
        NSMutableAttributedString *attributeStrForVerses = [[NSMutableAttributedString alloc] initWithString:self.verseOfTheDay.verse attributes:@{NSFontAttributeName:fontForVerses,NSParagraphStyleAttributeName:paragraph}];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"\n"];
        [attributeStrForChapters appendAttributedString:attributedString];
        
        [attributeStrForChapters appendAttributedString:attributeStrForVerses];
        
        _VOTDTextView.attributedText = attributeStrForChapters;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    _activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];
    
    [operation start];
}


- (IBAction)searchTheQuery:(id)sender
{
    _autocompleteList.hidden = YES;
    [Flurry logEvent:@"SearchButtonPressed"];
    [_textFieldForSearching resignFirstResponder];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    
    NSDictionary *dictionaryOfResults = [self.searchManager searchResultsForString:_textFieldForSearching.text];
    
    stringToBeSent = dictionaryOfResults[STRINGTOBESENT];
    
    if ([dictionaryOfResults[RETURNVALUEKEY] boolValue])
    {
        [Flurry logEvent:@"Sucessful SearchButtonPress"];
    }
    
    return [dictionaryOfResults[RETURNVALUEKEY] boolValue];
}

-(void)managerResultString:(NSString *)result returnValue:(BOOL)returnValue andOccuranceOfString:(BOOL)occurance
{
    if (!returnValue)
    {
        if (occurance)
        {
            _textFieldForSearching.textColor = [UIColor redColor];
            _textFieldForSearching.font = [UIFont fontWithName:@"JamesFajardo" size:27];
            
            [UIView transitionWithView:self.textFieldForSearching duration:.6 options:(UIViewAnimationOptionAllowAnimatedContent) animations:^{
                _textFieldForSearching.text =result;
            } completion:Nil];

        }else
        {
            [self showWarningMessageWithAutoCompleteList:YES];
        }
    }
}

- (IBAction)returnKeyPressed:(UITextField *)sender
{
    [sender resignFirstResponder];
    
    [Flurry logEvent:@"Enter button pressed"];
    
    
    NSDictionary *dictionaryOfResults = [self.searchManager searchResultsForString:_textFieldForSearching.text];
    
    stringToBeSent = dictionaryOfResults[STRINGTOBESENT];
    
    if ([dictionaryOfResults[RETURNVALUEKEY] boolValue])
    {
        [Flurry logEvent:@"Sucessful enter button press"];
        _autocompleteList.hidden = YES;
        [self performSegueWithIdentifier:@"searchID" sender:self];
    }
}

- (IBAction)resignKeyboard:(id)sender
{
    _autocompleteList.hidden = YES;
    [_textFieldForSearching resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _autocompleteList.hidden = YES;
    
    if ([segue.identifier isEqualToString:@"searchID"])
    {
        ResultsListedViewController *tableViewController = segue.destinationViewController;
        tableViewController.searchQuery = stringToBeSent;
        _textFieldForSearching.text = @"";
    }
}


//To get autocomplete results
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring
{
    [autoCompleteArray removeAllObjects];
    
//    NSMutableArray *arryForFirstList = [[NSMutableArray alloc] init];
//    NSMutableArray *arrayOfSecondList = [[NSMutableArray alloc] init];
//    
//    UIFont *fontForRangeOfSubstring;
//    UIFont *fontForStringExecptSubstring;
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//    {
//        fontForRangeOfSubstring = [UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:20];
//        fontForStringExecptSubstring = [UIFont fontWithName:@"Baskerville-Italic" size:20];
//    }else
//    {
//        fontForRangeOfSubstring = [UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:18];
//        fontForStringExecptSubstring = [UIFont fontWithName:@"Baskerville-Italic" size:18];
//    }
//    if (SYSTEM_VERSION_LESS_THAN(@"6.0"))
//    {
//        
//        for (NSMutableAttributedString *currentAttributedString in arrayOfKeyWords)
//        {
//            NSString *currentString = [currentAttributedString string];
//            
//            NSRange rangeOfCurrentString;
//            rangeOfCurrentString.location = 0;
//            rangeOfCurrentString.length = [currentString length];
//            
//            [currentAttributedString addAttribute:UITextAttributeFont value:fontForStringExecptSubstring range:rangeOfCurrentString];
//            
//            NSRange substringRange = [currentString rangeOfString:substring options:NSCaseInsensitiveSearch];
//            
//            if ( substringRange.location == 0)
//            {
//                [currentAttributedString addAttribute:UITextAttributeFont value:fontForRangeOfSubstring range:substringRange];
////                [currentAttributedString setAttributes:@{UITextAttributeFont: fontForRangeOfSubstring} range:substringRange];
//                [arryForFirstList addObject:currentAttributedString];
//            } else if ( substringRange.location != NSNotFound & substringRange.location != 0)
//            {
//                [currentAttributedString addAttribute:UITextAttributeFont value:fontForRangeOfSubstring range:substringRange];
//                [arrayOfSecondList addObject:currentAttributedString];
//            }
//        }
//
//    }else
//    {
//        for (NSMutableAttributedString *currentAttributedString in arrayOfKeyWords)
//        {
//            NSString *currentString = [currentAttributedString string];
//            
//            NSRange rangeOfCurrentString;
//            rangeOfCurrentString.location = 0;
//            rangeOfCurrentString.length = [currentString length];
//            
//            [currentAttributedString addAttribute:NSFontAttributeName value:fontForStringExecptSubstring range:rangeOfCurrentString];
//            
//            NSRange substringRange = [currentString rangeOfString:substring options:NSCaseInsensitiveSearch];
//            
//            if ( substringRange.location == 0)
//            {
//                [currentAttributedString addAttribute:NSFontAttributeName value:fontForRangeOfSubstring range:substringRange];
//                [arryForFirstList addObject:currentAttributedString];
//            } else if ( substringRange.location != NSNotFound & substringRange.location != 0)
//            {
//                [currentAttributedString addAttribute:NSFontAttributeName value:fontForRangeOfSubstring range:substringRange];
//                [arrayOfSecondList addObject:currentAttributedString];
//            }
//        }
//    }
//    
//    
//    [arryForFirstList addObjectsFromArray:arrayOfSecondList];
//    if ([arryForFirstList count] != 0)
//    {
//        autoCompleteArray = arryForFirstList;
//    } else
//    {
//        NSMutableAttributedString *noResultAttributedString =[[NSMutableAttributedString alloc] initWithString:@"No results found..."];
//        autoCompleteArray = [@[noResultAttributedString] mutableCopy];
//    }
//
    autoCompleteArray = [self.autoCompleteManager searchAutocompleteEntriesWithSubstring:substring];
    
    [self.autocompleteList reloadData];
    [_autocompleteList setContentOffset:(CGPointZero)];
    
    
//Tableview height according to number of cells
//    int maxNumberOfCell;
//    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//    {
//        if ([UIScreen mainScreen].bounds.size.height == 568)
//            maxNumberOfCell = 6;
//        else
//            maxNumberOfCell = 5;
//    } else  maxNumberOfCell = 7;
//    
//        CGFloat heigtOfTableView;
//
//        if (autoCompleteArray.count < maxNumberOfCell)
//        {
//            heigtOfTableView = _autocompleteList.rowHeight * autoCompleteArray.count;
//            
//        } else
//        {
//            heigtOfTableView = _autocompleteList.rowHeight * maxNumberOfCell;
//        }
    
    
    _autocompleteHeightConst.constant = [self.autoCompleteManager heightOfTableForArrayCount:autoCompleteArray.count andRowHeight:self.autocompleteList.rowHeight];
    

//    CGRect frameOfTableView = _autocompleteList.frame;
//    frameOfTableView.size.height = heigtOfTableView;
//    _autocompleteList.frame = frameOfTableView;
}


#pragma mark
#pragma TExtfield delegte methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_textFieldForSearching.text isEqualToString:@"  Please ask somethig here..."] || [_textFieldForSearching.text isEqualToString:@"  Please ask something meaningful..."])
    {
        _textFieldForSearching.textColor = [UIColor blackColor];
        _textFieldForSearching.font = fontForTxtFldWhileEditing;
        
        [UIView transitionWithView:self.textFieldForSearching duration:.6 options:(UIViewAnimationOptionTransitionCrossDissolve) animations:^{
            _textFieldForSearching.text = @"";
            
        } completion:Nil];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _autocompleteList.hidden = NO;
    NSString *subString = [NSString stringWithString:textField.text];
    subString = [subString stringByReplacingCharactersInRange:range withString:string];

    [self searchAutocompleteEntriesWithSubstring:subString];

    
    if (subString.length == 0)
    {
        _autocompleteList.hidden = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    _autocompleteList.hidden = YES;
    return YES;
}

#pragma mark
#pragma Tableview delegate and datasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return autoCompleteArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"autocompleteID";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    
    //tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.contentSize.height);
    
    NSString *stringForIndex = [[autoCompleteArray objectAtIndex:indexPath.row] string];
    
    if (![stringForIndex isEqualToString:@"No results found..."])
    {
        cell.textLabel.font = [UIFont fontWithName:@"Baskerville-Italic" size:18];
        cell.textLabel.textColor = [UIColor blackColor];
    } else
    {
        cell.textLabel.font = [UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:16];
        cell.textLabel.textColor = [UIColor redColor];
    }
    
    cell.textLabel.attributedText = [autoCompleteArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *stringForIndex = [[autoCompleteArray objectAtIndex:indexPath.row] string];
    
    if (![stringForIndex isEqualToString:@"No results found..."])
    {
        _autocompleteList.hidden = YES;

        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        [Flurry logEvent:@"Autocomplete list used"];
        
        
        _textFieldForSearching.text = selectedCell.textLabel.attributedText.string;
    }
}

- (void)showWarningMessageWithAutoCompleteList:(BOOL)hidden
{
    _warningMessageView.hidden = NO;
    [UIView animateWithDuration:.5 animations:^{
        _warningMessageView.alpha = 1;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.5 delay:1 options:(UIViewAnimationOptionCurveLinear)| UIViewAnimationOptionBeginFromCurrentState animations:^{
            _warningMessageView.alpha = 0;
        } completion:^(BOOL finished) {
            _warningMessageView.hidden = YES;
        }];
        
    }];
    
    _autocompleteList.hidden = hidden;
}

@end
