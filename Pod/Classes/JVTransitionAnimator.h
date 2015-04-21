//
//  JVTransitionAnimator.h
//  Pods
//
//  Created by Jorge Valbuena on 2015-04-20.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface JVTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>


#pragma mark - UIViewControllerAnimatedTransitioning protocol methods

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext;


#pragma mark - UIViewControllerTransitioningDelegate protocol methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;


#pragma mark - Transition Animations

- (void)performPushOffScreenAnimationWithDuration:(CGFloat)duration;


@end