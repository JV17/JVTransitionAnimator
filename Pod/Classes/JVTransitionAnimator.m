//
//  JVTransitionAnimator.m
//  Pods
//
//  Created by Jorge Valbuena on 2015-04-20.
//
//

#import "JVTransitionAnimator.h"


@interface JVTransitionAnimator() <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIViewControllerInteractiveTransitioning>

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

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *upGesture;

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *downGesture;

@property (nonatomic) CGFloat percent;

@end


static CGFloat const kDelay = 0.0f;

static CGFloat const kDuration = 0.3f / 1.5f;

static CGFloat const kTransform2D = 3.14159265359;


@implementation JVTransitionAnimator

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if(transitionContext)
    {
        _transitionContext = transitionContext;
    }
    else
    {
        return;
    }
    
    _container = [self.transitionContext containerView];
    _fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
    _toView = [self.transitionContext viewForKey:UITransitionContextToViewKey];
    
    _animationDuration = [self transitionDuration:self.transitionContext];
    
    [self performSelectedAnimation];
}


- (void)performSelectedAnimation
{
    if (self.pushOnScreenAnimation)
    {
        [self performPushOnScreenAnimation];
    }
    else if (self.slideInOutAnimation)
    {
        [self performSlideInOutAnimation];
    }
    else if (self.slideUpDownAnimation)
    {
        [self performSlideUpDownAnimation];
    }
    else if (self.zoomInAnimation)
    {
        [self performZoomInAnimation];
    }
    else if (self.zoomOutAnimation)
    {
        [self performZoomOutAnimation];
    }
    else
    {
        [self performSlideInOutAnimation];
    }
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.animationDuration)
    {
        return self.animationDuration;
    }
    
    return kDuration;
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.presenting = YES;
    return self;
}


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


#pragma mark - Custom Accessors

- (void)setFromViewController:(UIViewController *)fromViewController
{
    _fromViewController = fromViewController;
    
    self.presenting = YES;

    if(self.slideUpDownAnimation)
    {
        // TODO: Remove this when implementation is finish
        // [self.fromViewController.view.window addGestureRecognizer:self.upGesture];
        // [self.fromViewController.view.window addGestureRecognizer:self.downGesture];
    }
    else
    {
        [self.fromViewController.view.window addGestureRecognizer:self.rightGesture];
        [self.fromViewController.view.window addGestureRecognizer:self.leftGesture];
    }
}


- (void)setSlideUpDownAnimation:(BOOL)slideUpDownAnimation
{
    _slideUpDownAnimation = slideUpDownAnimation;
    
    self.presenting = YES;
    
    if(self.slideUpDownAnimation)
    {
        // TODO: Remove this when implementation is finish
        // adding gestures
        // [self.fromViewController.view.window addGestureRecognizer:self.upGesture];
        // [self.fromViewController.view.window addGestureRecognizer:self.downGesture];
        // [self.fromViewController.view.window removeGestureRecognizer:self.rightGesture];
        // [self.fromViewController.view.window removeGestureRecognizer:self.leftGesture];
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


- (UIScreenEdgePanGestureRecognizer *)upGesture
{
    if(!_upGesture)
    {
        _upGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        _upGesture.edges = UIRectEdgeTop;
    }
    
    return _upGesture;
}


- (UIScreenEdgePanGestureRecognizer *)downGesture
{
    if(!_downGesture)
    {
        _downGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        _downGesture.edges = UIRectEdgeBottom;
    }
    
    return _downGesture;
}


#pragma mark - Gesture Recognizer

- (void)handleGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)pan
{
    if (!self.enabledInteractiveTransitions || self.zoomInAnimation || self.zoomOutAnimation)
    {
        NSLog(@"JVTransitionAnimator: Interactive Transition are not anabled or available for Zoom IN/OUT animations!");
        return;
    }
    
    // TODO: remove this after implementation is finished!
    if (self.slideUpDownAnimation)
    {
        NSLog(@"JVTransitionAnimator: Interactive Transition are not available yet for Slide UP/DOWN animations!");
        return;
    }
    
    if (!self.fromViewController || !self.toViewController)
    {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Please make sure fromViewController and toViewController properties have been set/initialize." userInfo:nil];
    }

    [self updatePercentageWithPanRecognizer:pan];
    [self updateViewFromPanState:pan.state];
}


- (void)updatePercentageWithPanRecognizer:(UIScreenEdgePanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:pan.view];

    if(self.slideUpDownAnimation)
    {
        if(self.presenting)
        {
            self.percent = translation.y / -(pan.view.bounds.size.height * 0.9);
        }
        else
        {
            self.percent = translation.y / (pan.view.bounds.size.height * 1.5);
        }
    }
    else
    {
        if(self.presenting)
        {
            self.percent = translation.x / -(pan.view.bounds.size.width * 0.5);
        }
        else
        {
            self.percent = translation.x / (pan.view.bounds.size.width * 0.5);
        }
    }
}


- (void)updateViewFromPanState:(UIGestureRecognizerState)state
{
    switch (state)
    {
        case UIGestureRecognizerStateBegan:
        {
            self.interactive = YES;
            
            if (self.toViewController && self.presenting)
            {
                [self.fromViewController presentViewController:self.toViewController animated:YES completion:^{
                    self.presenting = NO;
                }];
            }
            else if (self.toViewController && !self.presenting)
            {
                [self.toViewController dismissViewControllerAnimated:YES completion:^{
                    self.presenting = YES;
                }];
            }
            
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self updateInteractiveTransition:self.percent];
            
            break;
        }
        default:
        {
            self.interactive = NO;
            [self finishInteractiveTransition];
            
            break;
        }
    }
}


#pragma mark - Transition Animations

- (void)performPushOnScreenAnimation
{
    self.offScreenRight = CGAffineTransformMakeRotation(-(kTransform2D / 2));
    self.offScreenLeft = CGAffineTransformMakeRotation(kTransform2D / 2);
    
    self.toView.transform = self.presenting ? self.offScreenRight : self.offScreenLeft;
    
    CGPoint oldFromViewAnchorPoint = self.fromView.layer.anchorPoint;
    CGPoint oldToViewAnchorPoint = self.toView.layer.anchorPoint;

    self.toView.layer.anchorPoint = CGPointMake(0.0, 0.0);
    self.fromView.layer.anchorPoint = CGPointMake(0.0, 0.0);
    
    CGPoint oldFromViewPosition = self.fromView.layer.position;
    CGPoint oldToViewPosition = self.toView.layer.position;
    
    self.toView.layer.position = CGPointMake(0.0, 0.0);
    self.fromView.layer.position = CGPointMake(0.0, 0.0);
    
    [self.container addSubview:self.fromView];
    [self.container addSubview:self.toView];
    
    [self setAnimationOptionsWithDelay:kDelay dampling:0.4f velocity:0.8f options:0];
    
    [UIView animateWithDuration:self.animationDuration
                          delay:self.animationDelay
         usingSpringWithDamping:self.animationDamping
          initialSpringVelocity:self.animationVelocity
                        options:self.animationOptions
                     animations:^{

                         self.toView.transform = CGAffineTransformIdentity;
                         self.toView.alpha = 1.0;
                         self.fromView.alpha = 0.2;
                         
                     }
                     completion:^(BOOL finished) {
        
                         if (finished)
                         {
                             self.fromView.layer.position = oldFromViewPosition;
                             self.fromView.layer.anchorPoint = oldFromViewAnchorPoint;
                             self.toView.layer.position = oldToViewPosition;
                             self.toView.layer.anchorPoint = oldToViewAnchorPoint;
                             self.fromView.alpha = 1.0;
                             
                             [self.transitionContext completeTransition:YES];
                         }
                     }];
}


- (void)performSlideInOutAnimation
{
    CGFloat travelDistance = self.container.bounds.size.width;
    CGAffineTransform travel = CGAffineTransformMakeTranslation(self.presenting ? -travelDistance : travelDistance, 0);
    CGAffineTransform travel2 = CGAffineTransformMakeTranslation(self.presenting ? -travelDistance/4 : travelDistance / 4, 0);
    
    [self.container addSubview:self.toView];
    self.toView.transform = CGAffineTransformInvert(travel);
    
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
                         
                     }
                     completion:^(BOOL finished) {

                         if(finished)
                         {
                             self.fromView.transform = CGAffineTransformIdentity;
                             self.fromView.alpha = 1;
                            
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
                         
                     }
                     completion:^(BOOL finished) {
                         
                         if(finished)
                         {
                             self.fromView.transform = CGAffineTransformIdentity;
                             self.fromView.alpha = 1;
                             
                             [self.transitionContext completeTransition:YES];
                         }
                     }];
}


- (void)performZoomInAnimation
{
    [self.container addSubview:self.toView];
    self.toView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
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
                         
                     }
                     completion:^(BOOL finished) {
                         
                         if(finished)
                         {
                             self.fromView.alpha = 1;
                             
                             [self.transitionContext completeTransition:YES];
                         }
                     }];
}


- (void)performZoomOutAnimation
{
    [self.container addSubview:self.toView];
    self.toView.transform = CGAffineTransformIdentity;
    self.toView.alpha = 0;
    
    [self setAnimationOptionsWithDelay:kDelay dampling:1.0f velocity:0.9f options:0];
    
    [UIView animateWithDuration:self.animationDuration
                          delay:self.animationDelay
                        options:self.animationOptions
                     animations:^{
                         
                         self.fromView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                         self.fromView.alpha = 0;
                         self.toView.alpha = 1;
                         
                     }
                     completion:^(BOOL finished) {
                         
                         if(finished)
                         {
                             self.fromView.transform = CGAffineTransformIdentity;
                             
                             [self.transitionContext completeTransition:YES];
                         }
                     }];
}


#pragma mark - Animation Options

- (void)setAnimationOptionsWithDelay:(CGFloat)delay dampling:(CGFloat)dampling velocity:(CGFloat)velocity options:(UIViewAnimationOptions)options
{
    self.animationDelay = (self.animationDelay == 0.0f) ? delay : self.animationDelay;
    self.animationDamping = (self.animationDamping == 0.0f) ? dampling : self.animationDamping;
    self.animationVelocity = (self.animationVelocity == 0.0f) ? velocity : self.animationVelocity;
    self.animationOptions = (self.animationOptions == 0) ? options : self.animationOptions;
}

@end