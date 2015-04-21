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
    [JVAppHelper setGradientBackgroundInView:self.view withFirstHexColor:@"FF5E3A" andSecondHexColor:@"FF2A68"];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, CGRectGetMidY(self.view.frame)-25, CGRectGetWidth(self.view.frame), 50);
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.textColor = [UIColor blackColor];
    button.titleLabel.text = @"Click Me!";
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"Dismiss Me!" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showTransitionAnimation:) forControlEvents:UIControlEventTouchUpInside];
    
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