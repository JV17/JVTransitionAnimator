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

@property (nonatomic, strong) NSArray *buttons;

@end


@implementation JVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // gradient background color
    [JVAppHelper setGradientBackgroundInView:self.view withFirstHexColor:@"1AD6FD" andSecondHexColor:@"1D62F0"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 40)];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:26];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"JVTransitionAnimator";
    [self.view addSubview:label];
    
    self.buttons = @[[self createButtonWithFrame:CGRectMake(20, CGRectGetMidY(self.view.frame)-120, CGRectGetWidth(self.view.frame)-40, 40)
                                        andTitle:@"Push Off Screen Animation"
                                   andTargetName:@selector(showPushOffScreenAnimation:)],
                     [self createButtonWithFrame:CGRectMake(20, CGRectGetMidY(self.view.frame)-60, CGRectGetWidth(self.view.frame)-40, 40)
                                        andTitle:@"Slide In/Out Animation"
                                   andTargetName:@selector(showSlideInOutAnimation:)],
                     [self createButtonWithFrame:CGRectMake(20, CGRectGetMidY(self.view.frame), CGRectGetWidth(self.view.frame)-40, 40)
                                        andTitle:@"Zoom In Animation"
                                   andTargetName:@selector(showZoomInAnimation:)],
                     [self createButtonWithFrame:CGRectMake(20, CGRectGetMidY(self.view.frame)+60, CGRectGetWidth(self.view.frame)-40, 40)
                                        andTitle:@"Zoom Out Animation"
                                   andTargetName:@selector(showZoomOutAnimation:)]];
    
    for(int x = 0; x < self.buttons.count; x++) {
        [self.view addSubview:self.buttons[x]];
    }
    
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

- (void)showPushOffScreenAnimation:(UIButton *)button
{
    self.secondController.transitioningDelegate = self.transitionAnimator;
    self.transitionAnimator.pushOffScreenAnimation = YES;
    self.transitionAnimator.slideInOutAnimation = NO;
    self.transitionAnimator.zoomInAnimation = NO;
    self.transitionAnimator.zoomOutAnimation = NO;
    [self presentViewController:self.secondController animated:YES completion:nil];
}

- (void)showSlideInOutAnimation:(UIButton *)button
{
    self.secondController.transitioningDelegate = self.transitionAnimator;
    self.transitionAnimator.slideInOutAnimation = YES;
    self.transitionAnimator.pushOffScreenAnimation = NO;
    self.transitionAnimator.zoomInAnimation = NO;
    self.transitionAnimator.zoomOutAnimation = NO;
    [self presentViewController:self.secondController animated:YES completion:nil];
}

- (void)showZoomInAnimation:(UIButton *)button
{
    self.secondController.transitioningDelegate = self.transitionAnimator;
    self.transitionAnimator.slideInOutAnimation = NO;
    self.transitionAnimator.pushOffScreenAnimation = NO;
    self.transitionAnimator.zoomInAnimation = YES;
    self.transitionAnimator.zoomOutAnimation = NO;
    [self presentViewController:self.secondController animated:YES completion:nil];
}

- (void)showZoomOutAnimation:(UIButton *)button
{
    self.secondController.transitioningDelegate = self.transitionAnimator;
    self.transitionAnimator.slideInOutAnimation = NO;
    self.transitionAnimator.pushOffScreenAnimation = NO;
    self.transitionAnimator.zoomInAnimation = NO;
    self.transitionAnimator.zoomOutAnimation = YES;
    [self presentViewController:self.secondController animated:YES completion:nil];
}

- (UIButton *)createButtonWithFrame:(CGRect)frame andTitle:(NSString *)title andTargetName:(SEL)target
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.backgroundColor = [JVAppHelper colorWithHexString:@"C7C7CC"];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.textColor = [UIColor blackColor];
    button.titleLabel.text = title;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    
    button.layer.cornerRadius = 20;
    
    [button addTarget:self action:target forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end