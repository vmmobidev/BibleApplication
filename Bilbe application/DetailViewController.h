//
//  DetailViewController.h
//  Bilbe application
//
//  Created by Rahul kumar on 11/20/13.
//  Copyright (c) 2013 Vmoksha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Verse.h"

@interface DetailViewController : UIViewController < NSLayoutManagerDelegate, UIScrollViewDelegate, UITextViewDelegate >
@property (weak, nonatomic) IBOutlet UITextView *detailView;
@property (weak, nonatomic) IBOutlet UIButton *scrollUpButton;
@property (weak, nonatomic) IBOutlet UIButton *scrollDownButton;

@property (strong, nonatomic) Verse *verse;
- (IBAction)shareBtnAction:(UIButton *)sender;


@end
