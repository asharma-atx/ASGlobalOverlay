# ASGlobalOverlay

![Pod Version](https://img.shields.io/cocoapods/v/ASGlobalOverlay.svg?style=flat)
![Pod Platform](https://img.shields.io/cocoapods/p/ASGlobalOverlay.svg?style=flat)
![Pod License](https://img.shields.io/cocoapods/l/ASGlobalOverlay.svg?style=flat)

ASGlobalOverlay is a singleton pop-over controller that can display alerts, slide-up menus, and is-working indicators on top of your app. It's easy to implement and features a modern look and feel.

![alt tag](http://i.imgur.com/6WpSPFS.png)

## Demo

View a [GIF](http://i.imgur.com/pxD75ds.gifv) of the demo app, or try it out yourself by running `pod try ASGlobalOverlay`.

## Installation & Setup

Install using [CocoaPods](http://cocoapods.org):

````ruby
pod 'ASGlobalOverlay'
````
Call the setup helper from your app delegate:

```objective-c
#import <ASGlobalOverlay/ASGlobalOverlay.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

    [ASGlobalOverlay setupGlobalOverlay];

    return YES;
}
```

That's it! You're up and running.

## Quick Start

Typical use of `ASGlobalOverlay` looks something like this:

```objective-c

- (void)showAlert{

    ASUserOption * add = [ASUserOption userOptionWithTitle:@"Add" actionBlock:^{NSLog(@"'Add' pressed]");}];
    ASUserOption * cancel = [ASUserOption cancelUserOptionWithTitle:@"Cancel" actionBlock:^{NSLog(@"'Cancel' pressed");}];

    [ASGlobalOverlay showAlertWithTitle:@"Add Friend" message:@"Are you sure you want add this friend?" userOptions:@[add, cancel]];
}

- (void)showSlideUpMenu{

    ASUserOption * delete = [ASUserOption destructiveUserOptionWithTitle:@"Delete" actionBlock:^{NSLog(@"'Delete' pressed");}];
    ASUserOption * cancel = [ASUserOption cancelUserOptionWithTitle:@"Cancel" actionBlock:^{NSLog(@"'Cancel' pressed");}];

    [ASGlobalOverlay showSlideUpMenuWithPrompt:@"Are you sure you want to delete this post?" userOptions:@[delete, cancel]];
}

- (void)showWorkingIndicator{

    [ASGlobalOverlay showWorkingIndicatorWithDescription:@"Loading"];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        // some background task
        dispatch_async(dispatch_get_main_queue(), ^{

            [ASGlobalOverlay dismissWorkingIndicator];
        });
    });
}

```
Check out the `ASGlobalOverlay` header and the `ASUserOption` header for additional info and handy helper methods.

Please read the following section for important implementation details.

# Configurations

```objective-c

- (void)customConfigurations{

  ASConfiguration * configuration = [ASConfiguration new];

  configuration.backgroundColor = yourColor;
  configuration.titleColor = yourColor;
  configuration.bodyColor = yourColor;
  configuration.workingSpinnerColor = yourColor;
  configuration.separatorLineColor = yourColor;
  configuration.buttonTitleColorNormal = yourColor;
  configuration.buttonTitleColorCancel = yourColor;
  configuration.buttonTitleColorDestructive = yourColor;

  configuration.titleFont = [UIFont fontWithName:@"Courier-Bold" size:17.0f];
  configuration.bodyFont = [UIFont fontWithName:@"Courier" size:14.0f];
  configuration.buttonTitleFont = [UIFont fontWithName:@"Courier" size:14.0f];

  [configuration makeCurrentConfiguration];
}

// be sure to read the ASConfiguration header!
// There are useful helper methods, including configuration presets and support for dynamic fonts.

```

## Usage & Behavior Notes

- If you would like to smoothly transition between the visible popover and a new popover, simply call the show method for the new popover. `ASGlobalOverlay` will smoothly transition the first popover out. You can also do this from inside an `actionBlock`.

- ASGlobalOverlay will not appear over (or disable) a keyboard. However, it can hide / show the keyboard for you (so that the user doesn't type anything while a pop-over is showing). Check out the example app or the `ASGlobalOverlay` header for details.

- ASGlobalOverlay methods that show or dismiss views should only be called on the main thread.

- It is not recommended that you use ASGlobalOverlay and SVProgressHUD together (see 'Credits' below for details).

## About

ASGlobalOverlay provides a consistent way to show pop-overs to the user.

## New Features in 1.2

* Customizable color schemes
* Customizable fonts
* Dynamic font support

## Planned Features

* Progress bar pop-over
* Automatic main-thread grabbing
* Custom pop-overs

*Planned features are subject to change.*

## Requirements

- iOS 8.0+
- ARC

## License

ASGlobalOverlay is available under the MIT license. See the LICENSE file for more info.

## Credit

`ASGlobalOverlay` is written and maintained by [Amit Sharma](https://github.com/asharma-atx).

The high-level architecture of `ASGlobalOverlay` is based on the the [SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD) code. SVProgressHUD is a fantastic library, and its developers deserve major kudos for their work.

Since ASGlobalOverlay and SVProgressHUD utilize similar code to position themselves in the view hierarchy, it is not recommended that you use them together.
