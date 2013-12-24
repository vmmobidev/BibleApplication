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

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *serachButton;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@end

@implementation SearchViewController
{
    NSMutableString *votdChatpter;
    NSMutableString *votdVerse;
    NSString *stringToBeSent;
    UIFont *fontForTxtFldWhileEditing;
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
    NSLog(@"Animation");
    
    _imageView.animationImages = @[[UIImage imageNamed:@"1.1.png"],[UIImage imageNamed:@"1.2.png"],[UIImage imageNamed:@"2.png"],[UIImage imageNamed:@"3.1.png"],[UIImage imageNamed:@"3.2.png"],[UIImage imageNamed:@"4.1.png"],[UIImage imageNamed:@"4.2.png"],[UIImage imageNamed:@"5.1.png"],[UIImage imageNamed:@"5.2.png"],[UIImage imageNamed:@"6.png"],[UIImage imageNamed:@"7.1.png"],[UIImage imageNamed:@"7.2.png"],[UIImage imageNamed:@"8.png"],[UIImage imageNamed:@"9.1.png"],[UIImage imageNamed:@"9.2.png"],[UIImage imageNamed:@"10.png"],[UIImage imageNamed:@"11.png"],[UIImage imageNamed:@"12.png"],[UIImage imageNamed:@"13.1.png"],[UIImage imageNamed:@"13.2.png"],[UIImage imageNamed:@"14.1.png"],[UIImage imageNamed:@"14.2.png"],[UIImage imageNamed:@"15.png"]];
    
    _imageView.animationDuration = .8;
    _imageView.animationRepeatCount = 1;
    [_imageView startAnimating];

    fontForTxtFldWhileEditing = _textFieldForSearching.font;
    _textFieldForSearching.delegate = self;
    
    _serachButton.titleLabel.font = [UIFont fontWithName:@"JamesFajardo" size:26];
    _serachButton.titleLabel.textColor = [UIColor colorWithRed:222/255 green:204/255 blue:126/255 alpha:1];
    _serachButton.titleLabel.shadowColor = [UIColor blackColor];
    
    _serachButton.titleLabel.shadowOffset = CGSizeMake(2, 3);
    
    [_serachButton setBackgroundImage:[UIImage imageNamed:@"searchButton.png"] forState:UIControlStateNormal];
    
    _serachButton.adjustsImageWhenHighlighted = NO;
    
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
    
//    NSTimer *delayForVOTD = [NSTimer scheduledTimerWithTimeInterval:.8 target:self selector:@selector(getVOTDFromAPI) userInfo:Nil repeats:NO];
    
    self.title = @"Responses From Bible";
    
//    self.textFieldForSearching.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"textfield.png"]];
    
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

}

- (void)getVOTDFromAPI
{
    NSLog(@"VOTD");
    
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
        

    }];
    
    _activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];
    
    [operation start];
}


- (IBAction)searchTheQuery:(id)sender
{
    [_textFieldForSearching resignFirstResponder];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSMutableString *stringForTrimming = [_textFieldForSearching.text mutableCopy];
//remove special characters
    if (!stringToBeSent)
    {
        stringToBeSent = [[NSString alloc] init];
    }
    
    NSMutableCharacterSet *charactherSet = [NSMutableCharacterSet characterSetWithCharactersInString:@" "];
    [charactherSet formUnionWithCharacterSet:[NSCharacterSet alphanumericCharacterSet]];
    charactherSet = [[charactherSet invertedSet] mutableCopy];
    
    stringToBeSent = [[_textFieldForSearching.text componentsSeparatedByCharactersInSet:charactherSet] componentsJoinedByString:@""];
    
    
    if ([stringForTrimming stringByTrimmingCharactersInSet:([NSCharacterSet whitespaceAndNewlineCharacterSet])].length == 0)
    {
        _textFieldForSearching.textColor = [UIColor redColor];
        _textFieldForSearching.font = [UIFont fontWithName:@"JamesFajardo" size:27];
        _textFieldForSearching.text =@"  Ask somethig here...";
        return NO;
    }else if ([_textFieldForSearching.text isEqualToString:@"  Ask somethig here..."] || [_textFieldForSearching.text isEqualToString:@"  Please ask something meaningful..."])
    {
        return NO;
    }else if (stringToBeSent.length == 0)
    {
        _textFieldForSearching.textColor = [UIColor redColor];
        _textFieldForSearching.font = [UIFont fontWithName:@"JamesFajardo" size:27];
        _textFieldForSearching.text =@"  Please ask something meaningful...";
        return NO;
    }
    
    return YES;
}

- (IBAction)returnKeyPressed:(UITextField *)sender
{
    [sender resignFirstResponder];
    
    NSMutableString *stringForTrimming = [_textFieldForSearching.text mutableCopy];
    
    if (!stringToBeSent)
    {
        stringToBeSent = [[NSString alloc] init];
    }
    
    NSMutableCharacterSet *charactherSet = [NSMutableCharacterSet characterSetWithCharactersInString:@" "];
    [charactherSet formUnionWithCharacterSet:[NSCharacterSet alphanumericCharacterSet]];
    charactherSet = [[charactherSet invertedSet] mutableCopy];
    
    stringToBeSent = [[_textFieldForSearching.text componentsSeparatedByCharactersInSet:charactherSet] componentsJoinedByString:@""];


    if ([stringForTrimming stringByTrimmingCharactersInSet:([NSCharacterSet whitespaceAndNewlineCharacterSet])].length == 0)
    {
        _textFieldForSearching.textColor = [UIColor redColor];
        _textFieldForSearching.font = [UIFont fontWithName:@"JamesFajardo" size:27];
        _textFieldForSearching.text =@"  Ask somethig here...";

    }else if (stringToBeSent.length == 0)
    {
        _textFieldForSearching.textColor = [UIColor redColor];
        _textFieldForSearching.font = [UIFont fontWithName:@"JamesFajardo" size:27];
        _textFieldForSearching.text =@"  Please ask something meaningful...";
    }else
    {
        [self performSegueWithIdentifier:@"searchID" sender:self];

    }
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
        tableViewController.searchQuery = stringToBeSent;
        _textFieldForSearching.text = @"";
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_textFieldForSearching.text isEqualToString:@"  Ask somethig here..."] || [_textFieldForSearching.text isEqualToString:@"  Please ask something meaningful..."])
    {
        _textFieldForSearching.textColor = [UIColor blackColor];
        _textFieldForSearching.font = fontForTxtFldWhileEditing;
        _textFieldForSearching.text = @"";
    }
}

@end
