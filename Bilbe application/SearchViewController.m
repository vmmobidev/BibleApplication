//
//  SearchViewController.m
//  Bilbe application
//
//  Created by Rahul kumar on 11/20/13.
//  Copyright (c) 2013 Vmoksha. All rights reserved.
//

#import "SearchViewController.h"
#import "ResultsListedViewController.h"
#import "AFNetworking.h"
#import "Reachability.h"
#define URLForVOTD [NSURL URLWithString:@"http://labs.bible.org/api/?passage=votd&type=json"]

@interface SearchViewController ()

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@end

@implementation SearchViewController
{
    NSMutableString *votdChatpter;
    NSMutableString *votdVerse;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if ([UIScreen mainScreen].bounds.size.height == 568)
    {
        _serachFieldTopConst.constant=120;
        _imageViewBottomConst.constant = -330;
    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        _serachFieldTopConst.constant = 20.0f;
    } else
    {
    }
    
    _activityIndicator.hidden = YES;
    
    [self getVOTDFromAPI];
    
    self.title = @"Responds From Bible";
    
    self.textFieldForSearching.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"textfield.png"]];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    
    NSString *remoteHostName = @"www.google.com";

    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
	[self.hostReachability startNotifier];
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
        [self getVOTDFromAPI];
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
//
}

- (void)getVOTDFromAPI
{
    _verseOfTheDay = [[Verse alloc] init];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URLForVOTD];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = (NSData *)responseObject;
        NSError *error = nil;
        NSArray *parsedOutput = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if (error)
        {
            NSLog(@"%@: %@",error, [error userInfo]);
            
        } else
        {
            NSDictionary *dictonaryFromJson = parsedOutput[0];
            NSString *chapther = [NSString stringWithFormat:@"%@ %@:%@", dictonaryFromJson[@"bookname"], dictonaryFromJson[@"chapter"], dictonaryFromJson[@"verse"]];
            
            
            NSMutableString *verseOfTheDay = [dictonaryFromJson[@"text"] mutableCopy];
            
            while (1)
            {
                NSRange rangeForRemoving = [verseOfTheDay rangeOfString:@"<b>"];
                
                if (rangeForRemoving.location != NSNotFound)
                {
                    [verseOfTheDay deleteCharactersInRange:rangeForRemoving];
                }else
                    break;
            }
            
            while (1)
            {
                NSRange rangeForRemoving = [verseOfTheDay rangeOfString:@"</b>"];
                
                if (rangeForRemoving.location != NSNotFound)
                {
                    [verseOfTheDay deleteCharactersInRange:rangeForRemoving];
                }else
                    break;
            }
            
            
            _verseOfTheDay.chapter = chapther;
            _verseOfTheDay.verse = verseOfTheDay;
            
            _activityIndicator.hidden = YES;
            
            UIFont *fontForChapters = [UIFont fontWithName:@"JamesFajardo" size:33];
            UIFont *fontForVerses =[UIFont fontWithName:@"Desyrel" size:17.0];
            
            
            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
            paragraph.lineSpacing = 3.0f;
            paragraph.alignment = NSTextAlignmentCenter;
            
            NSMutableAttributedString *attributeStrForChapters = [[NSMutableAttributedString alloc] initWithString:self.verseOfTheDay.chapter attributes:@{NSFontAttributeName:fontForChapters,NSParagraphStyleAttributeName:paragraph, NSForegroundColorAttributeName: [UIColor redColor]}];
            
            NSMutableAttributedString *attributeStrForVerses = [[NSMutableAttributedString alloc] initWithString:self.verseOfTheDay.verse attributes:@{NSFontAttributeName:fontForVerses,NSParagraphStyleAttributeName:paragraph}];
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"\n"];
            [attributeStrForChapters appendAttributedString:attributedString];
            
            [attributeStrForChapters appendAttributedString:attributeStrForVerses];
            
            _VOTDTextView.attributedText = attributeStrForChapters;

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        UIAlertView *alertForNoNetwork = [[UIAlertView alloc] initWithTitle:@"No Internet Connectivity"  message:@"There is no internet connectvity. Please connect to internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alertForNoNetwork show];
    }];
    
    _activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];
    
    [operation start];
}


- (IBAction)searchTheQuery:(id)sender
{
    [_textFieldForSearching resignFirstResponder];
}

- (IBAction)returnKeyPressed:(UITextField *)sender
{
    [sender resignFirstResponder];
    [self performSegueWithIdentifier:@"searchID" sender:self];
}

- (IBAction)resignKeyboard:(id)sender
{
    [_textFieldForSearching resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"searchID"])
    {
        ResultsListedViewController *tableViewController = segue.destinationViewController;
        tableViewController.searchQuery = _textFieldForSearching.text;
        _textFieldForSearching.text = @"";
    }
}

@end
