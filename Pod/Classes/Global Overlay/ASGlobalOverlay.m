//
// ASGlobalOverlay
//
// Copyright (c) 2015 Amit Sharma <amitsharma@mac.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ASGlobalOverlay.h"
#import "ASAlertView.h"
#import "ASUserOption.h"
#import "ASSlideUpMenu.h"
#import "ASWorkingIndicator.h"
#import "ASButton.h"

const static CGFloat kTintOverlayAlpha = 0.6;

@interface ASGlobalOverlay () <ASAlertViewDismissalDelegate, ASSlideUpMenuDismissDelegate>

@property (nonatomic) NSInteger showingCount;

@property (strong, nonatomic) UIView *overlayContainer;
@property (strong, nonatomic) UIView *overlayTint;

@property (strong, nonatomic) ASAlertView *showingAlertView;
@property (strong, nonatomic) ASSlideUpMenu *showingSlideUpMenu;
@property (strong, nonatomic) ASWorkingIndicator *showingWorkingIndicator;

@property (nonatomic) CGFloat lastKnownKeyboardHeight;

@property (strong, nonatomic) NSTimer *dismissalTimer;

@property (nonatomic) BOOL responderResignedAutomatically;
@property (weak, nonatomic) id managedResponder;

@property (strong, nonatomic) ASConfigurationHandler *configurationHandler;

@end

@implementation ASGlobalOverlay

#pragma mark - Singleton Setup

+ (void)setupGlobalOverlay{
    
    [self sharedOverlay];
}

+ (instancetype)sharedOverlay{
    
    static dispatch_once_t once;
    static ASGlobalOverlay *sharedOverlay;
    
    dispatch_once(&once, ^{
        
        sharedOverlay = [[self alloc] privateInit];
        sharedOverlay.showingCount = 0;
        [sharedOverlay setupOverlayContainerAndTint];
        [sharedOverlay registerForKeyboardActivityNotifications];
        [sharedOverlay registerForLayoutRelatedNotifications];
    });
    
    return sharedOverlay;
}

- (instancetype)privateInit{
    
    return [super init];
}

- (void)registerForLayoutRelatedNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(layoutAllVisibleSubviews)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(layoutAllVisibleSubviews)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

#pragma mark - Showing Count Increment Controllers

/**
 *
 * This method should be called IMMEDIATELY AFTER a subview has been faded out and removed from the _overlayContainer.
 *
 * This method decreases the _showingCount value by 1.
 *
 * If the _showingCount value is reduced to 0, the _overlayContainer no longer contains subviews (except _tintOverlay), and needs to be dismissed.
 * As part of the dismissal process, the _overlayContainer and _overlayTint are removed from their superviews and nullified.
 * This dismissal clean-up occurs instantly. The fading out of _tintOverlay must occur beforehand if desired.
 *
 */

- (void)decrementShowingCountAndCleanUpIfNecessary{
    
    _showingCount --;
    if (_showingCount <= 0){
        
        [self removeAndNullifyOverlayContainerAndTintOverlay];
        [self makeManagedResponderFirstResponderIfAutomaticallyResignedAndNilReference];
    }
}

/**
 *
 * This method should be called IMMEDIATELY PRIOR to adding a subview to the _overlayContainer.
 *
 * This method adds 1 to the _showingCount.
 *
 * If the _showingCount value was increased to 1, that indicates that nothing was showing beforehand.
 * Since the _overlayContainer is removed from the view hierarchy if nothing is showing, a new _overlayContainer must be setup.
 *
 * If the _showingCount value was increased to a value greater than 1, something is already being shown, and an _overlayContainer already exist.
 * In this case, the view simply needs to be prepared for reuse.
 *
 */

- (void)incrementShowingCountAndPrepareContainerOverlayForNewSubview{
    
    _showingCount ++;
    
    if (_showingCount <= 1){ // anything less than 1 is never expected. <= is used as a safety measure.
        
        [self setupOverlayContainerAndTint];
        [self reframeOverlayContainerAndTintOverlay];
        [self resignManagedResponderIfFirstResponder];
    }
    
    else {
        
        [self prepareOverlayContainerForNewSubview];
    }
    
    [self invalidDismissalTimer];
}

/**
 *
 * Prepares the overlay container for reuse by removing all subviews from the container overlay, with two exceptions.
 *
 * The first exception for _tintOverlay, which is still needed if the container view is about to be reused.
 *
 * The second exception is for views that have indicated that they should not be removed.
 * These views are working on something, and will always remove themselves via delegate call once their work is complete.
 *
 */

- (void)prepareOverlayContainerForNewSubview{
    
    NSArray *subviews = [_overlayContainer subviews];
    
    for (UIView *view in subviews) {
        
        if (view != _overlayTint && view.tag != kDoNotRemoveViewTag){
            
            _showingCount --;
            [UIView animateWithDuration:0.2
                             animations:^{
                                 
                                 view.alpha = 0.0f;
                             }
             
                             completion:^(BOOL finished) {
                                 
                                 [view removeFromSuperview];
                             }];
        }
    }
}

#pragma mark - Overlay And Tint Control

- (void)setupOverlayContainerAndTint{
    
    [self removeAndNullifyOverlayContainerAndTintOverlay]; // shouldn't be necessary. safety measure
    
    _overlayContainer = [[UIView alloc]init];
    _overlayContainer.clipsToBounds = NO;
    _overlayContainer.backgroundColor = [UIColor clearColor];
    _overlayContainer.exclusiveTouch = YES;
    
    _overlayTint = [[UIView alloc]init];
    _overlayTint.backgroundColor = [UIColor blackColor];
    _overlayTint.alpha = 0.0f;
    
    [_overlayContainer addSubview:_overlayTint];
    [self addOverlayContainerToAppropriateWindow];
}

- (void)addOverlayContainerToAppropriateWindow{
    
    // this method was largely taken from SVProgressHUD. All credit goes to their incredible team.
    // https://github.com/SVProgressHUD/SVProgressHUD
    
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    
    for (UIWindow *window in frontToBackWindows){
        
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0.0f;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if(windowOnMainScreen && windowIsVisible && windowLevelNormal){
            
            if (![_overlayContainer isDescendantOfView:window])[window addSubview:_overlayContainer];
            break;
        }
    }
}

- (void)removeAndNullifyOverlayContainerAndTintOverlay{
    
    [_showingAlertView removeFromSuperview];
    [_showingSlideUpMenu removeFromSuperview];
    [_showingWorkingIndicator removeFromSuperview];
    
    _showingAlertView = nil;
    _showingSlideUpMenu = nil;
    _showingWorkingIndicator = nil;
    
    [_overlayContainer removeFromSuperview];
    [_overlayTint removeFromSuperview];
    
    _overlayContainer = nil;
    _overlayTint = nil;
}

#pragma mark - Alert View (Show)

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message userOptions:(NSArray *)userOptions{
    
    [[ASGlobalOverlay sharedOverlay] showAlertWithTitle:title message:message userOptions:userOptions];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message forTimePeriod:(NSTimeInterval)displayTime{
    
    [[ASGlobalOverlay sharedOverlay] showAlertWithTitle:title message:message userOptions:nil];
    [[ASGlobalOverlay sharedOverlay] dismissShowingAlertWithDelay:displayTime];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message dismissButtonTitle:(NSString *)buttonTitle{
    
    if (!buttonTitle) buttonTitle = @"Okay";
    ASUserOption *userOption = [ASUserOption userOptionWithTitle:buttonTitle actionBlock:nil];
    [[ASGlobalOverlay sharedOverlay] showAlertWithTitle:title message:message userOptions:@[userOption]];
}

- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message userOptions:(NSArray*)userOptions{
    
    [self incrementShowingCountAndPrepareContainerOverlayForNewSubview];
    
    _showingAlertView = [[ASAlertView alloc]initWithTitle:title
                                                  message:message
                                              userActions:userOptions
                                     configurationHandler:self.configurationHandler
                                                 delegate:self];
    
    [_showingAlertView layoutAndCenterInFrame:_overlayContainer.frame];
    [_overlayContainer addSubview:_showingAlertView];
    
    _showingAlertView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    _showingAlertView.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
         usingSpringWithDamping:0.75
          initialSpringVelocity:3.3
                        options:0
                     animations:^{
                         
                         _showingAlertView.alpha = 1.0f;
                         _showingAlertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         _overlayTint.alpha = kTintOverlayAlpha;
                     }
                     completion:nil
     ];
}

#pragma mark - Alert View (Dismiss)

// alerts can be dismissed either by calling the class dismissal method, or by the alert view itself via a delegate call.

+ (void)dismissAlertWithDelay:(NSTimeInterval)delay{
    
    [[ASGlobalOverlay sharedOverlay] dismissShowingAlertWithDelay:delay];
}

+ (void)dismissAlert{
    
    [[ASGlobalOverlay sharedOverlay] invalidDismissalTimer];
    [[ASGlobalOverlay sharedOverlay] dismissShowingAlertWithDelay:0.0f];
}

- (void)dismissShowingAlertWithNoDelay{
    
    [self dismissShowingAlertWithDelay:0.0f];
}

- (void)dismissShowingAlertWithDelay:(NSTimeInterval)delay{
    
    if (!_showingAlertView) return;
    
    if (delay == 0.0f) [self dismissAlertView:_showingAlertView];
    else [self reinitializeDismissalTimerWithTargetSelector:@selector(dismissShowingAlertWithNoDelay) interval:delay];
}

- (void)dismissAlertView:(ASAlertView *)alertView{
    
    if (!alertView) return;
    
    [UIView animateWithDuration:0.08f
                     animations:^{
                         
                         alertView.transform = CGAffineTransformMakeScale(1.06, 1.06);
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:.25f
                                          animations:^{
                                              
                                              alertView.transform = CGAffineTransformMakeScale(0.7, 0.7);
                                              alertView.alpha = 0.0f;
                                              if (_showingCount == 1) _overlayTint.alpha = 0.0f;
                                          }
                          
                                          completion:^(BOOL finished) {
                                              
                                              [alertView removeFromSuperview];
                                              [self decrementShowingCountAndCleanUpIfNecessary];
                                          }];
                     }];
}

#pragma mark - Slide Up Menu (Show)

+ (void)showSlideUpMenuWithPrompt:(NSString *)prompt userOptions:(NSArray *)userOptions{
    
    [[ASGlobalOverlay sharedOverlay] showSlideUpMenuWithPrompt:prompt userOptions:userOptions];
}

- (void)showSlideUpMenuWithPrompt:(NSString*)prompt userOptions:(NSArray*)userOptions{
    
    [self incrementShowingCountAndPrepareContainerOverlayForNewSubview];
    
    if (!userOptions || userOptions.count == 0) return;
    
    _showingSlideUpMenu = [[ASSlideUpMenu alloc]initWithPrompt:prompt
                                                   userActions:userOptions
                                        configurationHandler:self.configurationHandler
                                                      delegate:self];
    
    [_showingSlideUpMenu layoutAndPositionInFrame:_overlayContainer.frame];
    [_overlayContainer addSubview:_showingSlideUpMenu];
    
    _showingSlideUpMenu.transform = CGAffineTransformMakeTranslation(0, [_showingSlideUpMenu distanceToOffsetYForAnimation]);
    
    [UIView animateWithDuration:0.6
                          delay:0.0
         usingSpringWithDamping:0.75
          initialSpringVelocity:3.3
                        options:0
                     animations:^{
                         
                         _showingSlideUpMenu.transform = CGAffineTransformMakeTranslation(0, 0);
                         _overlayTint.alpha = kTintOverlayAlpha;
                     }
                     completion:nil
     ];
}

#pragma mark - Slide Up Menu (Dismiss)

// slide up menus can be dismissed either by calling the class dismissal method, or by the slide up menu itself via a delegate call

+ (void)dismissSlideUpMenu{
    
    [[ASGlobalOverlay sharedOverlay] invalidDismissalTimer];
    [[ASGlobalOverlay sharedOverlay] dismissShowingSlideUpMenu];
}

- (void)dismissShowingSlideUpMenu{
    
    [self dismissSlideUpMenu:_showingSlideUpMenu];
}

- (void)dismissSlideUpMenu:(ASSlideUpMenu *)slideUpMenu{
    
    if (!_showingSlideUpMenu) return;
        
    [UIView animateWithDuration:.25f
                     animations:^{
                         
                         slideUpMenu.transform = CGAffineTransformMakeTranslation(0, [slideUpMenu distanceToOffsetYForAnimation]);
                         if (_showingCount == 1) _overlayTint.alpha = 0.0f;
                     }
     
                     completion:^(BOOL finished) {
                         
                         [slideUpMenu removeFromSuperview];
                         [self decrementShowingCountAndCleanUpIfNecessary];
                     }
     ];
}

#pragma mark - Working Indicator (Show)

+ (void)showWorkingIndicatorWithDescription:(NSString *)description{
    
    [[ASGlobalOverlay sharedOverlay] showWorkingIndicatorWithDescription:description];
}

+ (void)showWorkingIndicatorWithDescription:(NSString *)description forTimePeriod:(NSTimeInterval)displayTime{
    
    [[ASGlobalOverlay sharedOverlay] showWorkingIndicatorWithDescription:description];
    [[ASGlobalOverlay sharedOverlay] dismissShowingWorkingIndicatorWithDelay:displayTime];
}

- (void)showWorkingIndicatorWithDescription:(NSString*)description{
    
    [self incrementShowingCountAndPrepareContainerOverlayForNewSubview];
    
    _showingWorkingIndicator = [[ASWorkingIndicator alloc]initWithDescription:description configurationHandler:self.configurationHandler];
    
    [_showingWorkingIndicator layoutAndCenterInFrame:_overlayContainer.frame];
    [_overlayContainer addSubview:_showingWorkingIndicator];
    
    _showingWorkingIndicator.alpha = 0.0f;
    _showingWorkingIndicator.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    [UIView animateWithDuration:0.3
                          delay:0.0
         usingSpringWithDamping:0.75
          initialSpringVelocity:3.3
                        options:0
                     animations:^{
                         
                         _showingWorkingIndicator.alpha = 1.0f;
                         _showingWorkingIndicator.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         _overlayTint.alpha = kTintOverlayAlpha;
                     } completion:nil
     ];
}

#pragma mark - Working Indicator (Dismiss)

// working indicators can only be dismissed by calling the class dismissal

+ (void)dismissWorkingIndicatorWithDelay:(NSTimeInterval)delay{
    
    [[ASGlobalOverlay sharedOverlay] dismissShowingWorkingIndicatorWithDelay:delay];
}

+ (void)dismissWorkingIndicator{
    
    [[ASGlobalOverlay sharedOverlay] invalidDismissalTimer];
    [[ASGlobalOverlay sharedOverlay] dismissShowingWorkingIndicatorWithNoDelay];
}

- (void)dismissShowingWorkingIndicatorWithNoDelay{
    
    [self dismissShowingWorkingIndicatorWithDelay:0.0f];
}

- (void)dismissShowingWorkingIndicatorWithDelay:(NSTimeInterval)delay{
    
    if (!_showingWorkingIndicator) return;
    
    if (delay == 0.0f) [self dismissWorkingIndicator:_showingWorkingIndicator];
    else [self reinitializeDismissalTimerWithTargetSelector:@selector(dismissShowingWorkingIndicatorWithNoDelay) interval:delay];
}

- (void)dismissWorkingIndicator:(ASWorkingIndicator *)workingIndicator{
    
    if (!workingIndicator) return;
    
    [UIView animateWithDuration:0.08f
                     animations:^{
                         
                         _showingWorkingIndicator.transform = CGAffineTransformMakeScale(1.1, 1.1);
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:.25f
                                          animations:^{
                                              
                                              _showingWorkingIndicator.transform = CGAffineTransformMakeScale(0.7, 0.7);
                                              _showingWorkingIndicator.alpha = 0.0f;
                                              if (_showingCount == 1) _overlayTint.alpha = 0.0f;
                                          }
                          
                                          completion:^(BOOL finished) {
                                              
                                              [_showingWorkingIndicator removeFromSuperview];
                                              [self decrementShowingCountAndCleanUpIfNecessary];
                                          }];
                     }];
}

#pragma mark - Dismiss Everything

+ (void)dismissEverythingImmediately{
    
    [[ASGlobalOverlay sharedOverlay] dismissEverythingImmediately];
}

- (void)dismissEverythingImmediately{
    
    [self invalidDismissalTimer];
    
    if(_showingAlertView) [_showingAlertView removeFromSuperview];
    if(_showingSlideUpMenu) [_showingSlideUpMenu removeFromSuperview];
    if(_showingWorkingIndicator) [_showingWorkingIndicator removeFromSuperview];
    
    _showingCount = 0;
    
    [self removeAndNullifyOverlayContainerAndTintOverlay];
}

#pragma mark - First Responder Management

+ (void)manageResponderStateDuringNextPopover:(id)responder{
    
    BOOL isTextFieldOrTextView = ([responder isKindOfClass:[UITextField class]] || [responder isKindOfClass:[UITextView class]]);
    
    if (isTextFieldOrTextView) [ASGlobalOverlay sharedOverlay].managedResponder = responder;
    else [ASGlobalOverlay sharedOverlay].managedResponder = nil;
}

- (void)resignManagedResponderIfFirstResponder{
    
    if (!_managedResponder || ![_managedResponder respondsToSelector:@selector(isFirstResponder)]) {
        
        _responderResignedAutomatically = NO;
    }
    
    else if ([_managedResponder isFirstResponder]){
        
        _responderResignedAutomatically = YES;
        [_managedResponder resignFirstResponder];
    }
}

- (void)makeManagedResponderFirstResponderIfAutomaticallyResignedAndNilReference{
    
    if (_responderResignedAutomatically && [_managedResponder respondsToSelector:@selector(becomeFirstResponder)]) {
        
        _responderResignedAutomatically = NO;
        [_managedResponder becomeFirstResponder];
    }
    
    _managedResponder = nil;
}

#pragma mark - Keyboard Management

- (void)registerForKeyboardActivityNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardActivityNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardActivityNotification:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardActivityNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardActivityNotification:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

- (void)handleKeyboardActivityNotification:(NSNotification *)notification{
    
    if (notification.name == UIKeyboardWillHideNotification || notification.name == UIKeyboardDidHideNotification) {
        
        _lastKnownKeyboardHeight = 0.0f;
    }
    
    else {
        
        NSValue *keyboardHeight = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
        _lastKnownKeyboardHeight = [keyboardHeight CGRectValue].size.height;
    }
    
    [self layoutAllVisibleSubviews];
}

#pragma mark - Timer Management

- (void)invalidDismissalTimer{
    
    [_dismissalTimer invalidate];
    _dismissalTimer = nil;
}

- (void)reinitializeDismissalTimerWithTargetSelector:(SEL)selector interval:(NSTimeInterval)interval{
    
    [self invalidDismissalTimer];
    
    _dismissalTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:selector userInfo:nil repeats:NO];
    _dismissalTimer.tolerance = 0.1f;
}

#pragma mark - Layout Management

- (void)reframeOverlayContainerAndTintOverlay{
    
    CGRect screenBounds = [UIApplication sharedApplication].keyWindow.bounds;
    
    _overlayContainer.frame = CGRectMake(0,
                                         0,
                                         screenBounds.size.width,
                                         screenBounds.size.height - _lastKnownKeyboardHeight
                                         );
    
    // padding ensures that the overlay covers the edges of the screen when the device is rotating.
    // padding intentionally does not adjust accommodate the keyboard b/c the keyboard may be split on iPad, leaving an un-tinted area between the two keyboard halves.
    _overlayTint.frame = CGRectMake(screenBounds.size.width * -.25,
                                    screenBounds.size.height * -.25,
                                    screenBounds.size.width * 1.50,
                                    screenBounds.size.height * 1.50);
}

- (void)layoutAllVisibleSubviews{
    
    [self reframeOverlayContainerAndTintOverlay];
    
    if (_showingAlertView) [_showingAlertView layoutAndCenterInFrame:_overlayContainer.frame];
    if (_showingSlideUpMenu) [_showingSlideUpMenu layoutAndPositionInFrame:_overlayContainer.frame];
    if (_showingWorkingIndicator) [_showingWorkingIndicator layoutAndCenterInFrame:_overlayContainer.frame];
}

#pragma mark - Configuration

+ (void)setConfiguration:(ASConfiguration *)configuration{
    
    if (!configuration || [configuration isMemberOfClass:[ASConfiguration class]]){
        
        [ASGlobalOverlay sharedOverlay].configurationHandler = nil;
        return;
    }
    
    [ASGlobalOverlay sharedOverlay].configurationHandler = [ASConfigurationHandler configurationHandlerWithConfiguration:configuration];
}

- (ASConfigurationHandler *)configurationHandler{
    
    if (!_configurationHandler) {
        
        _configurationHandler = [ASConfigurationHandler configurationHandlerWithConfiguration:nil];
    }
    
    return _configurationHandler;
}

#pragma mark - Visibility Helpers

+ (BOOL)isShowingAlert{
    
   return [[[ASGlobalOverlay sharedOverlay] showingAlertView] isDescendantOfView:[[ASGlobalOverlay sharedOverlay] overlayContainer]];
}

+ (BOOL)isShowingSlideUpMenu{
    
    return [[[ASGlobalOverlay sharedOverlay] showingSlideUpMenu] isDescendantOfView:[[ASGlobalOverlay sharedOverlay] overlayContainer]];
}

+ (BOOL)isShowingWorkingIndicator{
    
    return [[[ASGlobalOverlay sharedOverlay] showingWorkingIndicator] isDescendantOfView:[[ASGlobalOverlay sharedOverlay] overlayContainer]];
}

+ (BOOL)isVisible{
    
    if ([ASGlobalOverlay isShowingAlert] || [ASGlobalOverlay isShowingSlideUpMenu] || [ASGlobalOverlay isShowingWorkingIndicator]) return YES;
    
    return NO;
}

@end
