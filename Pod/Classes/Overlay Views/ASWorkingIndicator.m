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
const static CGFloat kMaxDescriptionLabelWidth = 300.0f;
const static CGFloat kDescriptionLabelHeight = 25.0f;
const static CGFloat kDescriptionLabelSideMargins = 16.0f;
const static CGFloat kDescriptionLabelBottomMargin = 8.0f;

const static CGFloat kDescriptionFontSize = 18.0f;

@interface ASWorkingIndicator ()

@property (nonatomic) BOOL hasDescription;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation ASWorkingIndicator

- (instancetype)initWithDescription:(NSString *)description{
    
    self = [super init];
    
    self.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0];
    self.layer.cornerRadius = 5.0f;
    self.clipsToBounds = YES;
    
    [self setupActivityIndicatorView];
    [self setupDescriptionLabelWithDescription:description];
    [self layoutAllSubviews];
    
    return self;
}

- (void)setupActivityIndicatorView{
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.color = [UIColor darkGrayColor];
    
    [self addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
}

- (void)setupDescriptionLabelWithDescription:(NSString *)description{
    
    if (description) _hasDescription = YES;
    else _hasDescription = NO;
    if (!_hasDescription) return;
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.text = description;
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.textColor = [UIColor darkGrayColor];
    _descriptionLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:kDescriptionFontSize];
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_descriptionLabel];
}

- (void)layoutAllSubviews{
    
    if (!_hasDescription) {
        _activityIndicator.frame = CGRectMake(1.5f, 0.0f, kDefaultSquareViewDimension, kDefaultSquareViewDimension);
    }
    
    else{
        
        CGFloat descriptionLabelWidth = [_descriptionLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
        if (descriptionLabelWidth > kMaxDescriptionLabelWidth) descriptionLabelWidth = kMaxDescriptionLabelWidth;
        
        _descriptionLabel.frame = CGRectMake(kDescriptionLabelSideMargins,
                                             kDefaultSquareViewDimension,
                                             descriptionLabelWidth,
                                             kDescriptionLabelHeight);
        
        _activityIndicator.frame = CGRectMake(kDescriptionLabelSideMargins + 1.5f,
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
        CGFloat selfHeight = kDefaultSquareViewDimension + kDescriptionLabelHeight + kDescriptionLabelBottomMargin;
        
        self.frame = CGRectMake((frame.size.width - selfWidth) / 2,
                                (frame.size.height - selfHeight) / 2,
                                selfWidth,
                                selfHeight);
    }
}

@end
