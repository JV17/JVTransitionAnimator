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
    self.duration = [self transitionDuration:self.transitionContext];

    // triggering the type of animation choosed
//    if(self.pushOffScreenAnimation)
//    {
//        [self performPushOffScreenAnimation];
//    }
//    else if(self.slideInOutAnimation)
//    {
//        [self performSlideInOutAnimation];
//    }
//    else if(self.zoomInAnimation)
//    {
//        [self performZoomInAnimation];
//    }
//    else if(self.zoomOutAnimation)
//    {
//        [self performZoomOutAnimation];
//    }
//    else
//    {
//        // we need a default animation
//        [self performSlideInOutAnimation];
//    }
    [self testAnimation];
    
}

// return how many seconds the transiton animation will take
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // this allows us to change the duration of our transitions
    if(self.duration != 0.0f) {
        return self.duration;
    }
    
    return kDuration;
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

- (void)performPushOffScreenAnimation
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
    [self.container addSubview:self.toView];
    [self.container addSubview:self.fromView];
    
    // we need to check if we have any custom values for our animations
    [self setAnimationOptionsWithDelay:kDelay dampling:0.4f velocity:0.8f options:0];
        
    // we slid both fromView and toView to the left at the same time
    // meaning fromView is pushed off the screen and toView slides into view
    // we also use the block animation usingSpringWithDamping for a little bounce
    [UIView animateWithDuration:self.duration
                          delay:self.delay
         usingSpringWithDamping:self.damping
          initialSpringVelocity:self.velocity
                        options:self.options
                     animations:^{

                         // slide fromView off either the left or right edge of the screen
                         // depending if we're presenting or dismissing this view
                         self.fromView.transform = self.presenting ? self.offScreenLeft : self.offScreenRight;
                         self.toView.transform = CGAffineTransformIdentity;
                         self.fromView.alpha = 0.0;
                         
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
    CGFloat travelDistance = self.container.bounds.size.width + 16.0f;
    CGAffineTransform travel = CGAffineTransformMakeTranslation(self.presenting ? -travelDistance : travelDistance, 0);
    
    [self.container addSubview:self.toView];
    self.toView.alpha = 0;
    self.toView.transform = CGAffineTransformInvert(travel);
    
    // we need to check if we have any custom values for our animations
    [self setAnimationOptionsWithDelay:kDelay dampling:0.4f velocity:0.9f options:0];
    
    [UIView animateWithDuration:self.duration
                          delay:self.delay
         usingSpringWithDamping:self.damping
          initialSpringVelocity:self.velocity
                        options:self.options
                     animations:^{
                         
                         self.fromView.transform = travel;
                         self.fromView.alpha = 0;
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
    self.toView.alpha = 0;
    self.toView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    // we need to check if we have any custom values for our animations
    [self setAnimationOptionsWithDelay:kDelay dampling:0.4f velocity:0.9f options:0];
    
    [UIView animateWithDuration:self.duration
                          delay:self.delay
         usingSpringWithDamping:self.damping
          initialSpringVelocity:self.velocity
                        options:self.options
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
    
    [UIView animateWithDuration:self.duration
                          delay:self.delay
                        options:self.options
                     animations:^{
                         
                         self.fromView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                         self.toView.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                         
                         if(finished) {
                             self.fromView.transform = CGAffineTransformIdentity;
                             
                             // tell our transitionContext object that we've finished animating
                             [self.transitionContext completeTransition:YES];
                         }
    
                     }];
}

- (void)testAnimation
{
    CGFloat travelDistance = self.container.bounds.size.width + 16.0f;
    CGAffineTransform travel = CGAffineTransformMakeTranslation(self.presenting ? -travelDistance : travelDistance, 0);
    
    [self.container addSubview:self.toView];
    self.toView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.toView.alpha = 0;
    self.toView.transform = CGAffineTransformInvert(travel);
    
    // we need to check if we have any custom values for our animations
    [self setAnimationOptionsWithDelay:kDelay dampling:0.4f velocity:0.9f options:0];
    
    [UIView animateWithDuration:self.duration
                          delay:self.delay
         usingSpringWithDamping:self.damping
          initialSpringVelocity:self.velocity
                        options:self.options
                     animations:^{
                         
                         self.fromView.transform = travel;
                         self.fromView.alpha = 0;
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


#pragma mark - Animation options setter

- (void)setAnimationOptionsWithDelay:(CGFloat)delay dampling:(CGFloat)dampling velocity:(CGFloat)velocity options:(UIViewAnimationOptions)options
{
    // we check if we have custom values for our animations else we use ours
    self.delay = (self.delay == 0.0f) ? delay : self.delay;
    self.damping = (self.damping == 0.0f) ? dampling : self.damping;
    self.velocity = (self.velocity == 0.0f) ? velocity : self.velocity;
    self.options = (self.options == 0) ? options : self.options;
}

@end