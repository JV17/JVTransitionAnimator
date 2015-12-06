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

/**
 The main view controller which will be presenting other view controller.
 */
@property (nonatomic, strong) UIViewController *fromViewController;


/**
 The destination view controller which is presented by you main view controller.
 */
@property (nonatomic, strong) UIViewController *toViewController;


/**
 Allows interactive transitions.
 */
@property (nonatomic, assign) BOOL enabledInteractiveTransitions;


#pragma mark - Animations Setup

/**
 The animation duration as a @CGFloat.
 */
@property (nonatomic) CGFloat animationDuration;


/**
 The animation delay as a @CGFloat.
 */
@property (nonatomic) CGFloat animationDelay;


/**
 The animation damping as a @CGFloat.
 */
@property (nonatomic) CGFloat animationDamping;


/**
 The animation velocity as a @CGFloat.
 */
@property (nonatomic) CGFloat animationVelocity;


/**
 The animation options as a @UIViewAnimationOptions.
 */
@property (nonatomic) UIViewAnimationOptions animationOptions;


#pragma mark - Animations Types

/**
 This animation will push the new view controller into the screen and off when dismissing it.
 */
@property (nonatomic) BOOL pushOnScreenAnimation;


/**
 This animation will slide in the new view controller into the screen and out when dismissing it.
 */
@property (nonatomic) BOOL slideInOutAnimation;


/**
 This animation will slide up the new view controller into the screen and down when dismissing it.
 */
@property (nonatomic) BOOL slideUpDownAnimation;


/**
 This animation will zoom in the new view controller into the screen.
 */
@property (nonatomic) BOOL zoomInAnimation;


/**
 This animation will zoom out the new view controller into the screen.
 */
@property (nonatomic) BOOL zoomOutAnimation;

@end