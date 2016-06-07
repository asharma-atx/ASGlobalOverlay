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

#import "ASWorkingIndicator.h"

const static CGFloat kDefaultSquareViewDimension = 70.0f;

const static CGFloat kDescriptionLabelSideMargins = 16.0f;
const static CGFloat kDescriptionLabelBottomMargin = 8.0f;

const static CGFloat kMaxDescriptionLabelWidth = 300.0f;
const static CGFloat kMaxDescriptionLabelHeight = 100.0f;

const static CGFloat kSpinnerCenteringOffset = 1.5f; // helps center spinner, since by default the top spinnger notch right-aligns to the frames center.

@interface ASWorkingIndicator ()

@property (nonatomic) BOOL hasDescription;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) ASConfigurationHandler *configurationHandler;

@end

@implementation ASWorkingIndicator

- (instancetype)initWithDescription:(NSString *)description configurationHandler:(ASConfigurationHandler *)configurationHandler{

    self = [super init];
    
    self.configurationHandler = configurationHandler;
    
    self.backgroundColor = [_configurationHandler backgroundColor];
    self.layer.cornerRadius = 5.0f;
    self.clipsToBounds = YES;
    
    [self setupActivityIndicatorView];
    [self setupDescriptionLabelWithDescription:description];
    [self layoutAllSubviews];
    
    return self;
}

- (void)setupActivityIndicatorView{
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.color = [_configurationHandler workingSpinnerColor];
    
    [self addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
}

- (void)setupDescriptionLabelWithDescription:(NSString *)description{
    
    _hasDescription = (description) ? YES : NO;
    if (!_hasDescription) return;
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.text = description;
    _descriptionLabel.backgroundColor = [_configurationHandler backgroundColor];
    _descriptionLabel.textColor = [_configurationHandler titleColor];
    _descriptionLabel.font = [_configurationHandler titleFont];
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_descriptionLabel];
}

- (void)layoutAllSubviews{
    
    if (!_hasDescription) {
        
        _activityIndicator.frame = CGRectMake(kSpinnerCenteringOffset, 0.0f, kDefaultSquareViewDimension, kDefaultSquareViewDimension);
    }
    
    else{
        
        CGSize labelSize = [_descriptionLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        CGFloat descriptionLabelWidth = MIN(labelSize.width, kMaxDescriptionLabelWidth);
        CGFloat descriptionLabelHeight = MIN(labelSize.height, kMaxDescriptionLabelHeight);
        
        _descriptionLabel.frame = CGRectMake(kDescriptionLabelSideMargins,
                                             kDefaultSquareViewDimension,
                                             descriptionLabelWidth,
                                             descriptionLabelHeight);
        
        _activityIndicator.frame = CGRectMake(kDescriptionLabelSideMargins + kSpinnerCenteringOffset,
                                              0.0f,
                                              descriptionLabelWidth,
                                              kDefaultSquareViewDimension);
    }
}

#pragma mark - Helpers

- (void)layoutAndCenterInFrame:(CGRect)frame{
    
    [self layoutAllSubviews];
    
    if (!_hasDescription) {
        
        self.frame = CGRectMake((frame.size.width - kDefaultSquareViewDimension) / 2,
                                (frame.size.height - kDefaultSquareViewDimension) / 2,
                                kDefaultSquareViewDimension,
                                kDefaultSquareViewDimension);
    }
    
    else{
        
        CGFloat selfWidth = _descriptionLabel.frame.size.width + kDescriptionLabelSideMargins * 2;
        CGFloat selfHeight = kDefaultSquareViewDimension + _descriptionLabel.frame.size.height + kDescriptionLabelBottomMargin;
        
        self.frame = CGRectMake((frame.size.width - selfWidth) / 2,
                                (frame.size.height - selfHeight) / 2,
                                selfWidth,
                                selfHeight);
    }
}

@end
