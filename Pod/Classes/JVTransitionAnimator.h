//
//  JVTransitionAnimator.h
//  Pods
//
//  Created by Jorge Valbuena on 2015-04-20.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface JVTransitionAnimator : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIViewControllerInteractiveTransitioning>

@property (nonatomic, strong) UIViewController *fromViewController;
@property (nonatomic, strong) UIViewController *toViewController;

@property (nonatomic, assign) BOOL enabledInteractiveTransitions;

@property (nonatomic) CGFloat animationDuration;
@property (nonatomic) CGFloat animationDelay;
@property (nonatomic) CGFloat animationDamping;
@property (nonatomic) CGFloat animationVelocity;
@property (nonatomic) UIViewAnimationOptions animationOptions;

// triggering animations
@property (nonatomic) BOOL pushOnScreenAnimation;
@property (nonatomic) BOOL slideInOutAnimation;
@property (nonatomic) BOOL slideUpDownAnimation;
@property (nonatomic) BOOL zoomInAnimation;
@property (nonatomic) BOOL zoomOutAnimation;

@end