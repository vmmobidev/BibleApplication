//
//  Test.m
//  Bilbe application
//
//  Created by Rahul kumar on 12/18/13.
//  Copyright (c) 2013 Vmoksha. All rights reserved.
//

#import "BackButton.h"

@implementation BackButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        
//        UIImage *backButtonImage = [[UIImage imageNamed:@"back-button.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 6.0)];
//        [self setBackgroundImage:backButtonImage  forState:UIControlStateNormal];
        [self setTitle:@"< Back " forState:UIControlStateNormal];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            self.titleLabel.font = [UIFont fontWithName:@"JamesFajardo" size:37];
        } else
            self.titleLabel.font = [UIFont fontWithName:@"JamesFajardo" size:30];
        
        
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
