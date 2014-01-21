//
//  InfoViewController.m
//  Quest For Bible Verses
//
//  Created by Rahul kumar on 1/20/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vmLogoToQuestLabelConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *questLabelToBottomConst;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@end

@implementation InfoViewController

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
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if ([UIScreen mainScreen].bounds.size.height != 568)
        {
            self.vmLogoToQuestLabelConst.constant = 20.0f;
            self.questLabelToBottomConst.constant = -293.0f;
        }
    }

 }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)requestWebsite:(UIButton *)sender
{
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://vmokshagroup.com/"]])
    {
        NSLog(@"Failed to open url");
    }
}

- (IBAction)moreAppFromDeveloper:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/in/artist/vmoksha-technologies-pvt./id543125173"]];
}

@end
