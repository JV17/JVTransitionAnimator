# JVTransitionAnimator [![Version](https://img.shields.io/cocoapods/v/JVTransitionAnimator.svg?style=flat)](http://cocoapods.org/pods/JVTransitionAnimator) [![License](https://img.shields.io/cocoapods/l/JVTransitionAnimator.svg?style=flat)](http://cocoapods.org/pods/JVTransitionAnimator) [![Platform](https://img.shields.io/cocoapods/p/JVTransitionAnimator.svg?style=flat)](http://cocoapods.org/pods/JVTransitionAnimator)

JVTransitionAnimator is a simple helper framework which allows you to present your View Controllers in a pretty cool way, with the use of Transition Animations. Pretty easy to use and customizable.

## Preview 1 - Pre-defined Animations

<a href="http://www.youtube.com/watch?feature=player_embedded&v=y8fEgyDxRYU?autoplay=1" target="_blank">![screenshot-1](Previews/preview1.gif)</a>

## Preview 2 - Custom Animations

<a href="http://www.youtube.com/watch?feature=player_embedded&v=y8fEgyDxRYU?autoplay=1" target="_blank">![screenshot-2](Previews/preview2.gif)</a>

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

* Now, just create a JVTransitionAnimator property

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

* Tell your View Controller that you want to use your own Transition Animations and the type of Animation you would like to use

```objc
    self.secondController.transitioningDelegate = self.transitionAnimator;
    self.transitionAnimator.pushOffScreenAnimation = YES;
    [self presentViewController:self.secondController animated:YES completion:nil];
```

* Also, we can futher setup and customize our Transition Animations

```objc
    self.secondController.transitioningDelegate = self.transitionAnimator;
    self.transitionAnimator.pushOffScreenAnimation = YES;

    // here is the trick if you want longer animations or set a delay or event not bouncing (known as dampling) at all
    self.transitionAnimator.duration = 1.0f;
    self.transitionAnimator.delay = 0.0f;
    self.transitionAnimator.damping = 0.5f;
    self.transitionAnimator.velocity = 0.9f;

    [self presentViewController:self.secondController animated:YES completion:nil];
```

## Requirements

Developed and tested using iOS8+.

## Installation

JVTransitionAnimtor is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JVTransitionAnimator"
```

## Author & Support

Contact me if you find any bugs or potential room for improvements. Jorge Valbuena (@JV17), jorgevalbuena2@gmail.com. BTW! You are welcome to help in supporting this pod or making improvements to it.

## License

JVTouchEventsWindow is available under the MIT license. See the LICENSE file for more info.