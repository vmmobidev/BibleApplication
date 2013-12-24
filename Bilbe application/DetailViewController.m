//
//  DetailViewController.m
//  Bilbe application
//
//  Created by Rahul kumar on 11/20/13.
//  Copyright (c) 2013 Vmoksha. All rights reserved.
//

#import "DetailViewController.h"
#import "BackButton.h"

@interface DetailViewController ()
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressForScollDown;

@end

@implementation DetailViewController
{
    NSTimer *timerForScrollingDown, *timerForScrollingUp;
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
    
    BackButton *backButton = [[BackButton alloc] initWithFrame: CGRectMake(0, 0, 60.0f, 30.0f)];
    
    [backButton addTarget:self action:@selector(backButtonisPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)backButtonisPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   
    self.title = [self.verse.chapter capitalizedString];
    self.scrollDownButton.hidden = YES;
    self.scrollUpButton.hidden = YES;
    
    self.detailView.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    UIFont *fontForTextView = [UIFont fontWithName:@"Desyrel" size:20];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:1.5];
//    paragraphStyle.alignment = NSTextAlignmentJustified;

    
//    NSDictionary *attributes = @{ NSFontAttributeName:fontForTextView, NSParagraphStyleAttributeName: paragraphStyle };
//    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.verse.verse attributes:attributes];
//
//    
//    _detailView.attributedText = attributedString;
    
    _detailView.textAlignment = NSTextAlignmentNatural;

    _detailView.font = fontForTextView;
    _detailView.text = self.verse.verse;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.detailView.contentSize.height >= self.detailView.bounds.size.height)
    {
        self.scrollDownButton.hidden = NO;
    }
    

}

- (IBAction)shareBtnAction:(UIButton *)sender
{
    UIFont *fontForChapters = [UIFont fontWithName:@"Arial" size:18.0];
    UIFont *fontForVerses =[UIFont fontWithName:@"Helvetica Neue" size:12.0];

    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    
    NSMutableAttributedString *attributeStrForChapters = [[NSMutableAttributedString alloc] initWithString:self.verse.chapter attributes:@{NSFontAttributeName:fontForChapters,NSParagraphStyleAttributeName:paragraph, NSForegroundColorAttributeName: [UIColor redColor]}];
    
    NSMutableAttributedString *attributeStrForVerses = [[NSMutableAttributedString alloc] initWithString:self.verse.verse attributes:@{NSFontAttributeName:fontForVerses,NSParagraphStyleAttributeName:paragraph}];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"\n"];
    [attributeStrForChapters appendAttributedString:attributedString];
    
    [attributeStrForChapters appendAttributedString:attributeStrForVerses];
    
    NSArray *dataToShare = @[attributeStrForChapters];
    UIActivityViewController *activityView =[[UIActivityViewController alloc]initWithActivityItems:dataToShare applicationActivities:Nil];
    activityView.excludedActivityTypes = @[UIActivityTypePrint,UIActivityTypeCopyToPasteboard];
    
    [activityView setCompletionHandler:^(NSString *activityType, BOOL completed) {
        if (completed) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Posted" message:@"Verses is sent sucessfully" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert show];
            
            NSLog(@"completed dialog - activity: %@ - finished flag: %d", activityType, completed);
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Unable To Share" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert show];

        }
        
    }];
     [self presentViewController:activityView animated:TRUE completion:nil];
}

- (void)showOrHideScrollButtonsForOffSet:(CGPoint)offset
{
//    NSLog(@"%f", offset.y );
    
    if (offset.y <= 0)
    {
        self.scrollUpButton.hidden = YES;
        [timerForScrollingUp invalidate];

    } else
    {
        if (self.scrollUpButton.hidden)
        {
            self.scrollUpButton.hidden = NO;
        }
    }
    
//    NSLog(@"Content height = %f",self.detailView.contentSize.height);
    if (offset.y >= self.detailView.contentSize.height - self.detailView.frame.size.height)
    {
        self.scrollDownButton.hidden = YES;
        [timerForScrollingDown invalidate];
    } else
    {
        if (self.scrollDownButton.hidden)
        {
            self.scrollDownButton.hidden = NO;
        }
    }
}

- (IBAction)scrollUpButtonAction
{
    CGPoint currentOffset = self.detailView.contentOffset;
    currentOffset.y = currentOffset.y - 30;
    [self.detailView setContentOffset:currentOffset animated:YES];
    [self showOrHideScrollButtonsForOffSet:currentOffset];
}

//- (IBAction)scrollUpButtonAction:(UIButton *)sender
//{
//    CGPoint currentOffset = self.detailView.contentOffset;
//    currentOffset.y = currentOffset.y - 30;
//    [self.detailView setContentOffset:currentOffset animated:YES];
//    [self showOrHideScrollButtonsForOffSet:currentOffset];
////    [self showOrHideScrollDownButtonForOffset:currentOffset];
//}
- (IBAction)scrollDownButtonAction
{
    CGPoint currentOffset = self.detailView.contentOffset;
    currentOffset.y = currentOffset.y + 30;
    
    [self.detailView setContentOffset:currentOffset animated:YES];
    
    [self showOrHideScrollButtonsForOffSet:currentOffset];
}

//- (IBAction)scrollDownButtonAction:(UIButton *)sender
//{
//    
////    [self showOrHideScrollDownButtonForOffset:currentOffset];
//}

- (IBAction)longPressForScrollDownButton:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        timerForScrollingDown = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(scrollDownButtonAction) userInfo:nil repeats:YES];
        [timerForScrollingDown fire];
        
    } else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [timerForScrollingDown invalidate];
    }
}
- (IBAction)longpressForScrollUpButton:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        timerForScrollingUp = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(scrollUpButtonAction) userInfo:nil repeats:YES];
//        [timerForScrollingUp fire];
        
    } else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [timerForScrollingUp invalidate];
    }
}

#pragma mark
#pragma Scrollview delegate method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self showOrHideScrollButtonsForOffSet:self.detailView.contentOffset];
}

@end