//
//  TestTableViewController.m
//  Bilbe application
//
//  Created by Rahul kumar on 11/20/13.
//  Copyright (c) 2013 Vmoksha. All rights reserved.
//

#import "ResultsListedViewController.h"
#import "DetailViewController.h"
#import "TestAppDelegate.h"
#import "ParserOfHTML.h"
#import "Verse.h"
#import "BackButton.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"

@interface ResultsListedViewController ()

@property (nonatomic) Reachability *hostReachability;

@end

@implementation ResultsListedViewController
{
    NSString *stringForParsing;
    NSString *currentElementOnParser;
    NSRange rangeOfFirstMatch;
    NSMutableArray *arrayOfChapter, *arrayOfVerses;
    NSMutableString *mutableString;
    NSData *dataForParsing;
    
    BOOL verseIsCompletelyCopied;
    NSMutableString *stringForAppendingVerses;
    
    UIView *activityView;
    UIActivityIndicatorView *activityWheel;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Title for navigationBar
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"List view is loaded");
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    
    NSString *remoteHostName = @"www.google.com";
    
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
	[self.hostReachability startNotifier];
    
    self.title = [_searchQuery capitalizedString];
    
    UIImageView *backgroudImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
    backgroudImageView.frame = self.tableView.frame;
    self.tableView.backgroundView = backgroudImageView;
    

    
    [self getSearchResults];
}

- (void)getSearchResults
{
    //Allocating the Arrays for parsing
    arrayOfChapter = [[NSMutableArray alloc] init];
    arrayOfVerses = [[NSMutableArray alloc] init];
    
    //Deleteing space in between key words
    NSMutableString *mutableSearchQuery = [_searchQuery mutableCopy];
    
    while (1)
    {
        NSRange rangeForReplaceing = [mutableSearchQuery rangeOfString:@" "];
        
        if (rangeForReplaceing.location != NSNotFound)
        {
            [mutableSearchQuery replaceCharactersInRange:rangeForReplaceing withString:@"_"];
        }else
            break;
    }
    
    NSString *URLString = [NSString stringWithFormat:@"http://www.openbible.info/topics/%@", mutableSearchQuery];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        dataForParsing = (NSData *)responseObject;
        mutableString = [[NSMutableString alloc] initWithData:dataForParsing encoding:(NSUTF8StringEncoding)];
        
        ParserOfHTML *parser = [[ParserOfHTML alloc] init];
        NSDictionary *dictionaryOfAllResults = [parser parseHTMLstring:mutableString];
        
        arrayOfVerses = dictionaryOfAllResults[@"verses"];
        arrayOfChapter = dictionaryOfAllResults[@"chapters"];
        [self.tableView reloadData];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [self hideActivityIndicatorView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self hideActivityIndicatorView];
         UIAlertView *alertForNoNetwork = [[UIAlertView alloc] initWithTitle:@"No Internet Connectivity"  message:@"There is no internet connectvity. Please connect to internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
         [alertForNoNetwork show];
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
     }];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self showActitviyIndicatorView];
    
    [operation start];
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    Reachability *reach = [notification object];
    NetworkStatus status = [reach currentReachabilityStatus];
    
    if (status == NotReachable)
    {
        UIAlertView *alertForNoNetwork = [[UIAlertView alloc] initWithTitle:@"No Internet Connectivity"  message:@"There is no internet connectvity. Please connect to internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertForNoNetwork show];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)loadView
{
    [super loadView];
    
    BackButton *backButton = [[BackButton alloc] initWithFrame: CGRectMake(0, 0, 60.0f, 30.0f)];
    
    [backButton addTarget:self action:@selector(backButtonisPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)backButtonisPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}


- (void)showActitviyIndicatorView
{
    TestAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = delegate.window;
    
    if (!activityView)
    {
        activityView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height)];
        activityView.backgroundColor = [UIColor blackColor];
        activityView.alpha = 0.5;
        
        activityWheel = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(window.bounds.size.width / 2 - 12, window.bounds.size.height / 2 - 12, 24, 24)];
        activityWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        activityWheel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                          UIViewAutoresizingFlexibleRightMargin |
                                          UIViewAutoresizingFlexibleTopMargin |
                                          UIViewAutoresizingFlexibleBottomMargin);
    }
    
    
    [activityView addSubview:activityWheel];
    [window addSubview: activityView];
    [activityWheel startAnimating];
}

- (void)hideActivityIndicatorView
{
    [activityWheel stopAnimating];
    
    [UIView animateWithDuration:.5 animations:^{
        activityView.alpha = 0;
    } completion:^(BOOL finished) {
        [activityView removeFromSuperview];
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayOfChapter count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    
    label.text = [arrayOfChapter objectAtIndex:indexPath.row];
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailID"])
    {
        DetailViewController *detailView = segue.destinationViewController;
        
        NSIndexPath *indexPAth = [self.tableView indexPathForSelectedRow];
        
        Verse *verse = [[Verse alloc] init];
        verse.chapter = [arrayOfChapter objectAtIndex:indexPAth.row];
        verse.verse = [arrayOfVerses objectAtIndex:indexPAth.row];
        
        detailView.verse = verse;
    }
}

@end
