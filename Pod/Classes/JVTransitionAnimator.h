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

// the main view controller which will be presenting other view controller
@property (nonatomic, strong) UIViewController *fromViewController; // *IMPORTANT FOR INTERACTIVE ANIMATIONS*

// destination view controller which is presented by you main view controller
@property (nonatomic, strong) UIViewController *toViewController; // *IMPORTANT FOR INTERACTIVE ANIMATIONS*

// this property enables the interactive animations
@property (nonatomic, assign) BOOL enabledInteractiveTransitions;

@property (nonatomic) CGFloat animationDuration; // set CGFloat value for animations duration
@property (nonatomic) CGFloat animationDelay; // set CGFloat value for animations delay
@property (nonatomic) CGFloat animationDamping; // set CGFloat value for animations damping
@property (nonatomic) CGFloat animationVelocity; // set CGFloat value for animations velocity
@property (nonatomic) UIViewAnimationOptions animationOptions; // set UIViewAnimationOptions for animations options

// triggering animations
@property (nonatomic) BOOL pushOnScreenAnimation; // set to YES to trigger pushOnScreenAnimations
@property (nonatomic) BOOL slideInOutAnimation; // set to YES to trigger slideInOutAnimations
@property (nonatomic) BOOL slideUpDownAnimation; // set to YES to trigger slideUpDownAnimation
@property (nonatomic) BOOL zoomInAnimation; // set to YES to trigger zoomInAnimation
@property (nonatomic) BOOL zoomOutAnimation; // set to YES to trigger zoomOutAnimation

@end