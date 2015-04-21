//
//  JVViewController.m
//  JVTransitionAnimtor
//
//  Created by Jorge Valbuena on 04/20/2015.
//  Copyright (c) 2014 Jorge Valbuena. All rights reserved.
//

#import "JVViewController.h"
#import "JVSecondViewController.h"

@interface JVViewController ()

@property (nonatomic, strong) JVTransitionAnimator *transitionAnimator;
@property (nonatomic, strong) JVSecondViewController *secondController;

@end


@implementation JVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // gradient background color
    [JVAppHelper setGradientBackgroundInView:self.view withFirstHexColor:@"1AD6FD" andSecondHexColor:@"1D62F0"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, CGRectGetMidY(self.view.frame)-25, CGRectGetWidth(self.view.frame), 50);
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.textColor = [UIColor blackColor];
    button.titleLabel.text = @"Click Me!";
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"Show Me!" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showTransitionAnimation:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Custom getters & setters

- (JVTransitionAnimator *)transitionAnimator
{
    if(!_transitionAnimator)
    {
        _transitionAnimator = [[JVTransitionAnimator alloc] init];
    }
    
    return _transitionAnimator;
}

- (JVSecondViewController *)secondController
{
    if(!_secondController)
    {
        _secondController = [[JVSecondViewController alloc] init];
    }
    
    return _secondController;
}


#pragma mark - Helper functions

- (void)showTransitionAnimation:(UIButton *)button
{
    self.secondController.transitioningDelegate = self.transitionAnimator;
    [self presentViewController:self.secondController animated:YES completion:nil];
}

@end