# JVTransitionAnimator [![Version](https://img.shields.io/cocoapods/v/JVTransitionAnimator.svg?style=flat)](http://cocoapods.org/pods/JVTransitionAnimator) [![License](https://img.shields.io/cocoapods/l/JVTransitionAnimator.svg?style=flat)](http://cocoapods.org/pods/JVTransitionAnimator) [![Platform](https://img.shields.io/cocoapods/p/JVTransitionAnimator.svg?style=flat)](http://cocoapods.org/pods/JVTransitionAnimator)

JVTransitionAnimator is a simple helper framework which allows you to present your View Controllers in a pretty cool way, with the use of Transition Animations. Pretty easy to use and customizable.

## Previews

###### • Custom Animations

<a href="http://www.youtube.com/watch?feature=player_embedded&v=6LySLa1raXk?autoplay=1" target="_blank">![screenshot-1](Previews/jvtransition.preview1.gif)</a>

###### • Pre-defined Animations

<a href="http://www.youtube.com/watch?feature=player_embedded&v=wwb_7fKS7F0?autoplay=1" target="_blank">![screenshot-2](Previews/jvtransition.preview3.gif)</a>

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

* Now, just create a JVTransitionAnimator property.

```objc
- (JVTransitionAnimator *)transitionAnimator
{
    if(!_transitionAnimator)
    {
        _transitionAnimator = [[JVTransitionAnimator alloc] init];
    }

    return _transitionAnimator;
}
```

* To enabled interactive transitions you do this, for example, in the viewDidAppear of your UIViewController. Also, we need to set our transition delegate.

```objc
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // we need to tell our transition animator the current view controller & the new controller to be pushed
    self.transitionAnimator.fromViewController = self;
    self.transitionAnimator.toViewController = self.secondController;

    // enabling interactive transitions
    self.transitionAnimator.enabledInteractiveTransitions = YES;

    // also don't forget to tell the new UIViewController to be presented that we will be using our animator & choose the animation
    self.transitionAnimator.slideInOutAnimation = YES;
    self.secondController.transitioningDelegate = self.transitionAnimator;
}
```

* Then, we can further setup and customize our Transition Animations.

```objc
// here is the trick if you want longer animations or set a delay or event not bouncing (known as dampling) at all
self.transitionAnimator.duration = 1.0f;
self.transitionAnimator.delay = 0.0f;
self.transitionAnimator.damping = 0.5f;
self.transitionAnimator.velocity = 0.9f;
```

* Finally, to trigger transitions we just need to make a simple presentViewController function call.

```objc
// whenever you want to present the new view controller animated
[self presentViewController:self.secondController animated:YES completion:nil];
```

## Requirements

Developed and tested using iOS11+.

## Installation

JVTransitionAnimtor is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JVTransitionAnimator"
```

## Author & Support

Contact me if you find any bugs or potential room for improvements. Jorge Valbuena (@JV17), jorge.valbuena@jorgedeveloper.com. BTW! You are welcome to help in supporting this pod or making improvements to it.

## License

JVTouchEventsWindow is available under the MIT license. See the LICENSE file for more info.
