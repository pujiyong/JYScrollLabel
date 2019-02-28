//
//  JYScrollLabel.m
//  test
//
//  Created by pjy on 2019/2/27.
//  Copyright © 2019 pjy. All rights reserved.
//

#import "JYScrollLabel.h"

static const NSTimeInterval kDefaultInterval = 2;
static const NSTimeInterval kDefaultDuration = 1;

@interface JYScrollLabel ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UILabel *currentLabel;
@property (nonatomic, strong) UILabel *lastLabel;

@end

@implementation JYScrollLabel

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

- (instancetype)initWithTexts:(NSArray *)texts {
    if (self = [super init]) {
        self.texts = texts;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    
    self.clipsToBounds = YES;
    
    self.currentLabel.frame = self.bounds;
    self.lastLabel.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
    [self addSubview:self.currentLabel];
    [self addSubview:self.lastLabel];
}

- (void)scrollAnimate {
    NSAssert(self.texts.count != 0, @"JYScrollLabel Exception: Texts can not be nil");
    
    if (self.texts.count == 1) {
        self.currentLabel.text = self.texts.firstObject;
        return;
    }
    
    NSString *currentText = self.texts[self.currentIndex];
    NSString *lastText = self.texts[self.currentIndex + 1 == self.texts.count ? 0 : self.currentIndex + 1];
    
    UILabel *topLable;
    UILabel *bottomLable;
    
    if (self.currentLabel.frame.origin.y < self.lastLabel.frame.origin.y) {
        topLable = self.currentLabel;
        bottomLable = self.lastLabel;
    } else {
        topLable = self.lastLabel;
        bottomLable = self.currentLabel;
    }
    
    topLable.text = currentText;
    bottomLable.text = lastText;
    
    [UIView animateWithDuration:self.animateDuration animations:^{
        topLable.frame = CGRectMake(0, -self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
        bottomLable.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
       topLable.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
    }];
    
    self.currentIndex = self.currentIndex + 1 == self.texts.count ? 0 : self.currentIndex + 1;;
}

#pragma mark - Action

- (void)tapAction {
    if (self.labelTapedAtIndex) {
        self.labelTapedAtIndex(self.currentIndex);
    }
}

#pragma mark - Public

- (void)startScroll {
    [self.timer fire];
}

- (void)stopScroll {
    [self.timer invalidate];
}

#pragma mark - Getter

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:kDefaultInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self scrollAnimate];
        }];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (NSTimeInterval)animateDuration {
    return _animateDuration ? : kDefaultDuration;
}

- (UILabel *)currentLabel {
    if (!_currentLabel) {
        _currentLabel = [[UILabel alloc] init];
    }
    return _currentLabel;
}

- (UILabel *)lastLabel {
    if (!_lastLabel) {
        _lastLabel = [[UILabel alloc] init];
    }
    return _lastLabel;
}

#pragma mark - Setter

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    self.currentLabel.font = textFont;
    self.lastLabel.font = textFont;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.currentLabel.textColor = textColor;
    self.lastLabel.textColor = textColor;
}

- (void)setIntervals:(NSTimeInterval)intervals {
    _intervals = intervals;
    self.timer = [NSTimer timerWithTimeInterval:intervals repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self scrollAnimate];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.currentLabel.frame = self.bounds;
    self.lastLabel.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
}

@end
