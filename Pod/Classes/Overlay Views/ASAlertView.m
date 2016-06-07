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

#import "ASAlertView.h"
#import "ASUserOption.h"
#import "ASButton.h"

// sizing-related constants
const static CGFloat kAlertViewWidth = 280;
const static CGFloat kTitleMarginSideSpace = 10;
const static CGFloat kTopToTitleMarginSpace = 18;
const static CGFloat kMessageSideMarginSpace = 10;
const static CGFloat kMessageTopBottomMarginSpace = 15;
const static CGFloat kMessageLabelWidth = kAlertViewWidth - kMessageSideMarginSpace * 2;
const static CGFloat kDefaultButtonHeight = 40.0f;

@interface ASAlertView () <ASButtonDismissDelegate>

@property (strong, nonatomic) UILabel *titleBannerLabel;
@property (strong, nonatomic) UILabel *alertMessageLabel;

@property (strong, nonatomic) NSArray *userOptionUserActions;
@property (strong, nonatomic) NSArray *userOptionButtons;

@property (nonatomic) BOOL containsMessage;
@property (nonatomic) BOOL containsAtLeastOneUserOption;

@property (weak, nonatomic) id<ASAlertViewDismissalDelegate> delegate;
@property (strong, nonatomic) ASConfigurationHandler *configurationHandler;

@end

@implementation ASAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message userActions:(NSArray *)userActions configurationHandler:(ASConfigurationHandler *)configurationHandler delegate:(id<ASAlertViewDismissalDelegate>)delegate{

    self = [super init];
    
    self.configurationHandler = configurationHandler;
    self.delegate = delegate;
    
    self.backgroundColor = [_configurationHandler backgroundColor];
    self.layer.cornerRadius = 5.0f;
    self.clipsToBounds = YES;
    
    [self setupTitleBannerWithTitle:title];
    [self setupAlertMessageWithMessage:message];
    [self setupUserOptionsBarWithOptions:userActions];
    
    return self;
}

- (void)setupTitleBannerWithTitle:(NSString *)title{
    
    _titleBannerLabel = [[UILabel alloc] init];
    _titleBannerLabel.backgroundColor = [UIColor clearColor];
    _titleBannerLabel.text = title ? title : @"Alert";
    _titleBannerLabel.font = [_configurationHandler titleFont];
    _titleBannerLabel.textColor = [_configurationHandler titleColor];
    _titleBannerLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_titleBannerLabel];
}

- (void)setupAlertMessageWithMessage:(NSString *)message{
    
    _containsMessage = (message);
    if (!_containsMessage) return;
    
    _alertMessageLabel = [[UILabel alloc]init];
    _alertMessageLabel.text = message;
    _alertMessageLabel.numberOfLines = 8;
    _alertMessageLabel.font = [_configurationHandler bodyFont];
    _alertMessageLabel.textColor = [_configurationHandler bodyColor];
    _alertMessageLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_alertMessageLabel];
}

- (void)setupUserOptionsBarWithOptions:(NSArray *)options{
    
    _containsAtLeastOneUserOption = (options.count > 0);
    if (!_containsAtLeastOneUserOption) return;

    _userOptionUserActions = options;
    NSMutableArray *mutableButtonsArray = [[NSMutableArray alloc]init];
    
    NSInteger numberAdded = 0;
    
    for (ASUserOption *userOption in options) {
        
        if (numberAdded == 8) break; // maxes the number of buttons to 8
        
        ASButton *newButton = [[ASButton alloc] initButtonViewWithUserAction:userOption configurationHandler:_configurationHandler delegate:self];
        [mutableButtonsArray addObject:newButton];
        [self addSubview:newButton];
        
        numberAdded ++;
    }
    
    _userOptionButtons = [NSArray arrayWithArray:mutableButtonsArray];
}

- (void)layoutAllSubviews{
    
    CGFloat titleBannerHeight = [_titleBannerLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    
    // title banner
    _titleBannerLabel.frame = CGRectMake(kTitleMarginSideSpace,
                                         kTopToTitleMarginSpace,
                                         kAlertViewWidth - kTitleMarginSideSpace * 2,
                                         titleBannerHeight);
    
    // alert message (if any)
    if (_containsMessage) {
        
        CGSize messageSize =  [_alertMessageLabel sizeThatFits:CGSizeMake(kMessageLabelWidth, CGFLOAT_MAX)];
        
        _alertMessageLabel.frame = CGRectMake(kMessageSideMarginSpace,
                                              kTopToTitleMarginSpace + titleBannerHeight + kMessageTopBottomMarginSpace,
                                              kMessageLabelWidth,
                                              messageSize.height);
    }
    
    // users buttons (if any)
    if (_containsAtLeastOneUserOption) {
        
        CGFloat buttonHeight = MAX(kDefaultButtonHeight, [self minimumButtonHeight]);
        
        CGFloat alertMessageOffset = _containsMessage ? _alertMessageLabel.frame.size.height + kMessageTopBottomMarginSpace : 0.0f;
        CGFloat originY = kTopToTitleMarginSpace + titleBannerHeight + kMessageTopBottomMarginSpace + alertMessageOffset;

        if ([self canFitButtonsInSingleRow]) {
            
            ASButton *buttonOne = (ASButton *)[_userOptionButtons firstObject];
            ASButton *buttonTwo = (ASButton *)[_userOptionButtons lastObject];
            buttonOne.frame = CGRectMake(kAlertViewWidth / 2, originY, kAlertViewWidth / 2, buttonHeight);
            buttonTwo.frame = CGRectMake(0, originY, kAlertViewWidth / 2, buttonHeight);
            [buttonTwo makeRightSideBorderHidden:NO];
        }
        
        else {
            
            int buttonIndex = 0;
            
            for (ASButton *button in _userOptionButtons) {
                
                CGFloat originYWithOffset = originY + buttonIndex * buttonHeight;
                
                button.frame = CGRectMake(0,
                                          originYWithOffset,
                                          kAlertViewWidth,
                                          buttonHeight);
                buttonIndex ++;
            }
        }
    }
}

- (BOOL)canFitButtonsInSingleRow{
    
    if (_userOptionButtons.count == 2){
        
        CGFloat buttonOneWidth = [(ASButton *)[_userOptionButtons firstObject] widthOfButtonLabel];
        CGFloat buttonTwoWidth = [(ASButton *)[_userOptionButtons lastObject] widthOfButtonLabel];
        CGFloat maxButtonWidth = kAlertViewWidth / 2 - 30;
        
        if (buttonOneWidth < maxButtonWidth && buttonTwoWidth < maxButtonWidth) { // includes margin space
            
            return YES;
        }
    }
    
    return NO;
}

- (CGFloat)minimumButtonHeight{
    
    CGFloat largestMinimumButtonHeight = 0.0f;
    
    for (ASButton *button in _userOptionButtons) {
        
        CGFloat minimumButtonHeight = [button minimumButtonHeight];
        largestMinimumButtonHeight = MAX(minimumButtonHeight, largestMinimumButtonHeight);
    }
    
    return largestMinimumButtonHeight;
}

#pragma mark - ASButtonDismissDelegate

- (void)dismissView{

    [_delegate dismissAlertView:self];
}

#pragma mark - Helpers

- (void)layoutAndCenterInFrame:(CGRect)frame{
    
    [self layoutAllSubviews];
    
    UIButton *lastButton = [_userOptionButtons lastObject];
    
    CGFloat totalHeight = 0.0f;
    
    if (_containsAtLeastOneUserOption && lastButton) totalHeight = lastButton.frame.origin.y + lastButton.frame.size.height;
    else if (_containsMessage) totalHeight = _alertMessageLabel.frame.origin.y + _alertMessageLabel.frame.size.height + kMessageTopBottomMarginSpace;
    else totalHeight = _titleBannerLabel.frame.size.height + kTopToTitleMarginSpace * 2;
    
    self.frame = CGRectMake((frame.size.width - kAlertViewWidth) / 2,
                            (frame.size.height - totalHeight) / 2,
                            kAlertViewWidth,
                            totalHeight
                            );
}

@end
