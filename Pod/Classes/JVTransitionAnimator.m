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
@property (nonatomic) BOOL interactive;

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIView *fromView;
@property (nonatomic, strong) UIView *toView;

@property (nonatomic) CGAffineTransform offScreenRight;
@property (nonatomic) CGAffineTransform offScreenLeft;

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *rightGesture;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *leftGesture;

@end


@implementation JVTransitionAnimator

static CGFloat const kDelay = 0.0f;
static CGFloat const kDuration = 0.3f/1.5f;

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
    
    // get the duration of the animation
    // DON'T just type '0.5s' -- the reason why won't make sense until the next post
    // but for now it's important to just follow this approach
    self.animationDuration = [self transitionDuration:self.transitionContext];

    // triggering the type of animation choosed
    if(self.pushOnScreenAnimation)
    {
        [self performPushOnScreenAnimation];
    }
    else if(self.slideInOutAnimation)
    {
        [self performSlideInOutAnimation];
    }
    else if(self.slideUpDownAnimation)
    {
        [self performSlideUpDownAnimation];
    }
    else if(self.zoomInAnimation)
    {
        [self performZoomInAnimation];
    }
    else if(self.zoomOutAnimation)
    {
        [self performZoomOutAnimation];
    }
    else
    {
        // we need a default animation
        [self performSlideInOutAnimation];
    }
    
}

// return how many seconds the transiton animation will take
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // this allows us to change the duration of our transitions
    if(self.animationDuration != 0.0f) {
        return self.animationDuration;
    }
    
    return kDuration;
}


#pragma mark - UIViewControllerTransitioningDelegate protocol methods

// return the animataor when presenting a viewcontroller
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


#pragma mark - Interactive Transitions

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactive ? self : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactive ? self : nil;
}


#pragma mark - Custom getters & setters

- (void)setFromViewController:(UIViewController *)fromViewController
{
    _fromViewController = fromViewController;
    
    // only enabled intereactive transition if user wants to
    if(self.enabledInteractiveTransitions)
    {
        // by default in first launch we need it set to true
        self.presenting = YES;
        
        // adding gestures
        [self.fromViewController.view.window addGestureRecognizer:self.rightGesture];
        [self.fromViewController.view.window addGestureRecognizer:self.leftGesture];
    }
}

- (UIScreenEdgePanGestureRecognizer *)rightGesture
{
    if(!_rightGesture)
    {
        _rightGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        _rightGesture.edges = UIRectEdgeRight;
    }
    
    return _rightGesture;
}

- (UIScreenEdgePanGestureRecognizer *)leftGesture
{
    if(!_leftGesture)
    {
        _leftGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        _leftGesture.edges = UIRectEdgeLeft;
    }
    
    return _leftGesture;
}

#pragma mark - Gesture Recognizer

- (void)handleGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)pan
{
    if(!self.enabledInteractiveTransitions) {
        return;
    }
    
    CGPoint translation = [pan translationInView:pan.view];
    
    CGFloat percent = translation.x / -CGRectGetWidth(pan.view.bounds) * 0.5;
    
    if(!self.presenting)
    {
        percent = translation.x / CGRectGetWidth(pan.view.bounds) * 0.5;
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            
            self.interactive = YES;
            
            if(self.toViewController && self.presenting)
            {
                [self.fromViewController presentViewController:self.toViewController animated:YES completion:^{
                    self.presenting = NO;
                }];
            }
            else if(self.toViewController && !self.presenting)
            {
                [self.toViewController dismissViewControllerAnimated:YES completion:^{
                    self.presenting = YES;
                }];
            }
            
            break;
            
        case UIGestureRecognizerStateChanged:
            
            [self updateInteractiveTransition:percent];
            
            break;
            
        default: // Ended, Cancelled, Failed...
            
            self.interactive = NO;
            [self finishInteractiveTransition];
            
            break;
    }
        
}


#pragma mark - Transition Animations

- (void)performPushOnScreenAnimation
{
    // set up from 2D transforms that we'll use in the animation
    CGFloat transforms2D = 3.14159265359;
    
    self.offScreenRight = CGAffineTransformMakeRotation(-transforms2D/2);
    self.offScreenLeft = CGAffineTransformMakeRotation(transforms2D/2);
    
    // prepare the toView for the animation
    self.toView.transform = self.presenting ? self.offScreenRight : self.offScreenLeft;
    
    // set the anchor point so that rotations happen from the top-left corner
    CGPoint oldFromViewAnchorPoint = self.fromView.layer.anchorPoint;
    CGPoint oldToViewAnchorPoint = self.toView.layer.anchorPoint;

    self.toView.layer.anchorPoint = CGPointMake(0.0, 0.0);
    self.fromView.layer.anchorPoint = CGPointMake(0.0, 0.0);
    
    CGPoint oldFromViewPosition = self.fromView.layer.position;
    CGPoint oldToViewPosition = self.toView.layer.position;
    // updating the anchor point also moves the position to we have to move the center position to the top-left to compensate
    self.toView.layer.position = CGPointMake(0.0, 0.0);
    self.fromView.layer.position = CGPointMake(0.0, 0.0);
    
    // add the both views to our view controller
    [self.container addSubview:self.fromView];
    [self.container addSubview:self.toView];
    
    // we need to check if we have any custom values for our animations
    [self setAnimationOptionsWithDelay:kDelay dampling:0.4f velocity:0.8f options:0];
    
    // we slid both fromView and toView to the left at the same time
    // meaning fromView is pushed off the screen and toView slides into view
    // we also use the block animation usingSpringWithDamping for a little bounce
    [UIView animateWithDuration:self.animationDuration
                          delay:self.animationDelay
         usingSpringWithDamping:self.animationDamping
          initialSpringVelocity:self.animationVelocity
                        options:self.animationOptions
                     animations:^{

                         // slide fromView off either the left or right edge of the screen
                         // depending if we're presenting or dismissing this view
                         // self.fromView.transform = self.presenting ? self.offScreenLeft : self.offScreenRight;
                         self.toView.transform = CGAffineTransformIdentity;
                         self.toView.alpha = 1.0;
                         self.fromView.alpha = 0.2;
                         
                     } completion:^(BOOL finished) {
        
                         if (finished) {

                             // reseting state for demo purposes
                             self.fromView.layer.position = oldFromViewPosition;
                             self.fromView.layer.anchorPoint = oldFromViewAnchorPoint;
                             self.toView.layer.position = oldToViewPosition;
                             self.toView.layer.anchorPoint = oldToViewAnchorPoint;
                             self.fromView.alpha = 1.0;
                             
                             // tell our transitionContext object that we've finished animating
                             [self.transitionContext completeTransition:YES];
                         }
                         
                     }];
}


- (void)performSlideInOutAnimation
{
    CGFloat travelDistance = self.container.bounds.size.width;
    CGAffineTransform travel = CGAffineTransformMakeTranslation(self.presenting ? -travelDistance : travelDistance, 0);
    CGAffineTransform travel2 = CGAffineTransformMakeTranslation(self.presenting ? -travelDistance/4 : travelDistance/4, 0);
    
    [self.container addSubview:self.toView];
    self.toView.transform = CGAffineTransformInvert(travel);
    
    // we need to check if we have any custom values for our animations
    [self setAnimationOptionsWithDelay:kDelay dampling:0.4f velocity:0.9f options:0];
    
    [UIView animateWithDuration:self.animationDuration
                          delay:self.animationDelay
         usingSpringWithDamping:self.animationDamping
          initialSpringVelocity:self.animationVelocity
                        options:self.animationOptions
                     animations:^{
                         
                         self.fromView.transform = travel2;
                         self.fromView.alpha = 0.2;
                         self.toView.transform = CGAffineTransformIdentity;
                         self.toView.alpha = 1;
                         
                     } completion:^(BOOL finished) {

                         if(finished) {
                             self.fromView.transform = CGAffineTransformIdentity;
                             self.fromView.alpha = 1;
                            
                             // tell our transitionContext object that we've finished animating
                             [self.transitionContext completeTransition:YES];
                         }
                
                     }];
}


- (void)performSlideUpDownAnimation
{
    CGFloat travelDistance = self.container.bounds.size.height;
    CGAffineTransform travel = CGAffineTransformMakeTranslation(0, self.presenting ? -travelDistance : travelDistance);
    CGAffineTransform travel2 = CGAffineTransformMakeTranslation(0, self.presenting ? -travelDistance/4 : travelDistance/4);
    
    [self.container addSubview:self.toView];
    self.toView.transform = CGAffineTransformInvert(travel);
    
    // we need to check if we have any custom values for our animations
    [self setAnimationOptionsWithDelay:kDelay dampling:0.4f velocity:0.9f options:0];
    
    [UIView animateWithDuration:self.animationDuration
                          delay:self.animationDelay
         usingSpringWithDamping:self.animationDamping
          initialSpringVelocity:self.animationVelocity
                        options:self.animationOptions
                     animations:^{
                         
                         self.fromView.transform = travel2;
                         self.fromView.alpha = 0.2;
                         self.toView.transform = CGAffineTransformIdentity;
                         self.toView.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                         
                         if(finished) {
                             self.fromView.transform = CGAffineTransformIdentity;
                             self.fromView.alpha = 1;
                             
                             // tell our transitionContext object that we've finished animating
                             [self.transitionContext completeTransition:YES];
                         }
                         
                     }];

}


- (void)performZoomInAnimation
{
    [self.container addSubview:self.toView];
    self.toView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    // we need to check if we have any custom values for our animations
    [self setAnimationOptionsWithDelay:kDelay dampling:0.4f velocity:0.9f options:0];
    
    [UIView animateWithDuration:self.animationDuration
                          delay:self.animationDelay
         usingSpringWithDamping:self.animationDamping
          initialSpringVelocity:self.animationVelocity
                        options:self.animationOptions
                     animations:^{
                         
                         self.toView.transform = CGAffineTransformIdentity;
                         self.toView.alpha = 1;
                         self.fromView.alpha = 0;
                         
                     } completion:^(BOOL finished) {
                         
                         if(finished) {
                             self.fromView.alpha = 1;
                             
                             // tell our transitionContext object that we've finished animating
                             [self.transitionContext completeTransition:YES];
                         }
                         
                     }];
}


- (void)performZoomOutAnimation
{
    [self.container addSubview:self.toView];
    self.toView.transform = CGAffineTransformIdentity;
    self.toView.alpha = 0;
    
    // we need to check if we have any custom values for our animations
    [self setAnimationOptionsWithDelay:kDelay dampling:1.0f velocity:0.9f options:0];
    
    [UIView animateWithDuration:self.animationDuration
                          delay:self.animationDelay
                        options:self.animationOptions
                     animations:^{
                         
                         self.fromView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                         self.fromView.alpha = 0;
                         self.toView.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                         
                         if(finished) {
                             self.fromView.transform = CGAffineTransformIdentity;
                             
                             // tell our transitionContext object that we've finished animating
                             [self.transitionContext completeTransition:YES];
                         }
    
                     }];
}


#pragma mark - Animation options setter

- (void)setAnimationOptionsWithDelay:(CGFloat)delay dampling:(CGFloat)dampling velocity:(CGFloat)velocity options:(UIViewAnimationOptions)options
{
    // we check if we have custom values for our animations else we use ours
    self.animationDelay = (self.animationDelay == 0.0f) ? delay : self.animationDelay;
    self.animationDamping = (self.animationDamping == 0.0f) ? dampling : self.animationDamping;
    self.animationVelocity = (self.animationVelocity == 0.0f) ? velocity : self.animationVelocity;
    self.animationOptions = (self.animationOptions == 0) ? options : self.animationOptions;
}

@end