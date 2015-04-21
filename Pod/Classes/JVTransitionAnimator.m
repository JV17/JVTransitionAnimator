//
//  JVTransitionAnimator.m
//  Pods
//
//  Created by Jorge Valbuena on 2015-04-20.
//
//

#import "JVTransitionAnimator.h"



@interface JVTransitionAnimator()

@property (nonatomic) BOOL presenting;

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIView *fromView;
@property (nonatomic, strong) UIView *toView;

@property (nonatomic) CGAffineTransform offScreenRight;
@property (nonatomic) CGAffineTransform offScreenLeft;

@end


@implementation JVTransitionAnimator

#pragma mark - UIViewControllerAnimatedTransitioning protocol methods

// animate a change from one viewcontroller to another
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // updating reference to transitionContext
    if(transitionContext)
    {
        self.transitionContext = transitionContext;
    }
    else
    {
        return;
    }
    
    // get reference to our fromView, toView and the container view that we should perform the transition in
    self.container = [self.transitionContext containerView];
    self.fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
    self.toView = [self.transitionContext viewForKey:UITransitionContextToViewKey];
    
    // set up from 2D transforms that we'll use in the animation
    CGFloat transforms2D = 3.14159265359;
    
    self.offScreenRight = CGAffineTransformMakeRotation(-transforms2D/2);
    self.offScreenLeft = CGAffineTransformMakeRotation(transforms2D/2);
    
    // prepare the toView for the animation
    self.toView.transform = self.presenting ? self.offScreenRight : self.offScreenLeft;
    
    // set the anchor point so that rotations happen from the top-left corner
    self.toView.layer.anchorPoint = CGPointMake(0.0, 0.0);
    self.fromView.layer.anchorPoint = CGPointMake(0.0, 0.0);
    
    // updating the anchor point also moves the position to we have to move the center position to the top-left to compensate
    self.toView.layer.position = CGPointMake(0.0, 0.0);
    self.fromView.layer.position = CGPointMake(0.0, 0.0);
    
    // add the both views to our view controller
    [self.container addSubview:self.toView];
    [self.container addSubview:self.fromView];
    
    // get the duration of the animation
    // DON'T just type '0.5s' -- the reason why won't make sense until the next post
    // but for now it's important to just follow this approach
    CGFloat duration = [self transitionDuration:self.transitionContext];
    
    // perform the animation!
    [self performPushOffScreenAnimationWithDuration:duration];
    
}

// return how many seconds the transiton animation will take
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3/1.5;
}


#pragma mark - UIViewControllerTransitioningDelegate protocol methods

// return the animataor when presenting a viewcontroller
// remmeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.presenting = YES;
    return self;
}

// return the animator used when dismissing from a viewcontroller
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.presenting = NO;
    return self;
}


#pragma mark - Transition Animations

- (void)performPushOffScreenAnimationWithDuration:(CGFloat)duration
{
    // we slid both fromView and toView to the left at the same time
    // meaning fromView is pushed off the screen and toView slides into view
    // we also use the block animation usingSpringWithDamping for a little bounce
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:0.65
          initialSpringVelocity:1.0
                        options:0
                     animations:^{

                         // slide fromView off either the left or right edge of the screen
                         // depending if we're presenting or dismissing this view
                         self.fromView.transform = self.presenting ? self.offScreenLeft : self.offScreenRight;
                         self.toView.transform = CGAffineTransformIdentity;
                         
                     } completion:^(BOOL finished) {
        
                         if (finished) {
                             // tell our transitionContext object that we've finished animating
                             [self.transitionContext completeTransition:YES];
                         }
                         
                     }];
}


@end