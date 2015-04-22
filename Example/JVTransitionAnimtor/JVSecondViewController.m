//
//  JVSecondViewController.m
//  JVTransitionAnimtor
//
//  Created by Jorge Valbuena on 2015-04-20.
//  Copyright (c) 2015 Jorge Valbuena. All rights reserved.
//

#import "JVSecondViewController.h"

@interface JVSecondViewController ()

@end


@implementation JVSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // gradient background color
    [JVAppHelper setGradientBackgroundInView:self.view withFirstHexColor:@"1AD6FD" andSecondHexColor:@"1D62F0"];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, CGRectGetMidY(self.view.frame)-CGRectGetHeight(self.view.frame)/2, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"Dismiss Me!" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:30];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.textColor = [UIColor blackColor];
    button.titleLabel.text = @"Dismiss Me!";
    
    [button addTarget:self action:@selector(showTransitionAnimation:) forControlEvents:UIControlEventTouchUpInside];
    
    button.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    button.titleLabel.layer.shadowOpacity = 0.8;
    button.titleLabel.layer.shadowRadius = 4;
    button.titleLabel.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
    
    [self.view addSubview:button];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Helper functions

- (void)showTransitionAnimation:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end