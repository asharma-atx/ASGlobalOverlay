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

#import "ASSlideUpMenu.h"
#import "ASButton.h"
#import "ASConfigurationsUnpacker.h"

const static CGFloat kSideMarginSpace = 15.0f;
const static CGFloat kPromptTopBottomMarginSpace = 15.0f;
const static CGFloat kPromptFontSize = 14.0f;
const static CGFloat kButtonHeight = 50.0f;
const static CGFloat kAnimationMarginSpace = 15.0f;

@interface ASSlideUpMenu () <ASButtonDismissDelegate>

@property (strong, nonatomic) UILabel *promptLabel;
@property (strong, nonatomic) NSArray *userOptionButtons; // refactor TODO see alert view

@property (weak, nonatomic) id<ASSlideUpMenuDismissDelegate> delegate;
@property (strong, nonatomic) ASConfigurationsUnpacker *unpacker;

@end

@implementation ASSlideUpMenu

- (instancetype)initWithPrompt:(NSString *)prompt userActions:(NSArray *)userActions configurations:(ASConfigurations *)configurations delegate:(id<ASSlideUpMenuDismissDelegate>)delegate{

    self = [super init];
    
    _unpacker = [ASConfigurationsUnpacker configurationUnpackerWithConfiguration:configurations];
    
    self.backgroundColor = [_unpacker backgroundColor];
    self.delegate = delegate;
    
    [self addPromptLabelToView:prompt];
    [self addUserOptionButtonsToView:userActions];
    
    return self;
}

- (void)addPromptLabelToView:(NSString *)prompt{
    
    if (!prompt) return;
    
    _promptLabel = [[UILabel alloc]init];
    _promptLabel.text = prompt;
    _promptLabel.textAlignment = NSTextAlignmentCenter;
    _promptLabel.numberOfLines = 0.0f;
    _promptLabel.font = [_unpacker bodyFont];
    _promptLabel.textColor = [_unpacker bodyColor];
    
    [self addSubview:_promptLabel];
}

- (void)addUserOptionButtonsToView:(NSArray *)options{
    
    NSMutableArray *mutableButtonArray = [[NSMutableArray alloc]init];
    
    NSInteger numberAdded = 0;
    
    for (ASUserOption *userOption in options) {
        
        if (numberAdded == 8) break; // maxes the number of buttons to 8
        
        ASButton *newButton = [[ASButton alloc] initButtonViewWithUserAction:userOption configuration:_unpacker delegate:self];
        [self addSubview:newButton];
        [mutableButtonArray addObject:newButton];
        
        numberAdded ++;
    }
    
    _userOptionButtons = [NSArray arrayWithArray:mutableButtonArray];
}

#pragma mark - Layout

- (void)layoutSubviews{
    
    CGSize promptSize = [_promptLabel sizeThatFits:CGSizeMake(self.frame.size.width - kSideMarginSpace * 2, CGFLOAT_MAX)];
    _promptLabel.frame = CGRectMake(kSideMarginSpace,
                                    kPromptTopBottomMarginSpace,
                                    self.frame.size.width - kSideMarginSpace * 2,
                                    promptSize.height);
    
    CGFloat buttonYOriginOffset = 0.0f;
    if (_promptLabel) buttonYOriginOffset += _promptLabel.frame.size.height + kPromptTopBottomMarginSpace * 2;
    
    CGFloat buttonHeight = MAX(kButtonHeight, [self minimumButtonHeight]);
    
    for (ASButton *alertButton in _userOptionButtons) {
        
        alertButton.frame = CGRectMake(0,
                                       buttonYOriginOffset,
                                       self.frame.size.width,
                                       buttonHeight);
        
        buttonYOriginOffset += buttonHeight;
    }
}

- (CGFloat)minimumButtonHeight{ // refactor
    
    CGFloat largestMinimumButtonHeight = 0.0f;
    
    for (ASButton *button in _userOptionButtons) {
        
        CGFloat minimumButtonHeight = [button minimumButtonHeight];
        largestMinimumButtonHeight = MAX(minimumButtonHeight, largestMinimumButtonHeight); // refactor
    }
    
    return largestMinimumButtonHeight;
}

- (CGFloat)calculateHeightOfViewForWidth:(CGFloat)width{
    
    CGFloat promptLabelAndMarginsHeight = 0.0f;
    
    if (_promptLabel){
        
        CGFloat promptLabelHeight = [_promptLabel sizeThatFits:CGSizeMake(width - kSideMarginSpace * 2, CGFLOAT_MAX)].height;
        promptLabelAndMarginsHeight = promptLabelHeight + kPromptTopBottomMarginSpace * 2;
    }
    
    CGFloat heightOfUserOptions = MAX(kButtonHeight, [self minimumButtonHeight]) * _userOptionButtons.count; // refactor -- safey consids.
    
    return heightOfUserOptions + promptLabelAndMarginsHeight;
}

- (void)layoutAndPositionInFrame:(CGRect)frame{
    
    CGFloat heightOfView = [self calculateHeightOfViewForWidth:frame.size.width];
    self.frame = CGRectMake(0,
                            frame.size.height - heightOfView,
                            frame.size.width,
                            heightOfView + kAnimationMarginSpace); // space to compensate for animation "springiness" when the menu slides in
}

- (CGFloat)distanceToOffsetYForAnimation{ // space to compensate for animation "springiness" when the menu slides in
    
    return self.frame.size.height - kAnimationMarginSpace;
}

#pragma mark - ASButtonDismissDelegate

-(void)dismissView{
    
    [_delegate dismissSlideUpMenu:self];
}

@end
