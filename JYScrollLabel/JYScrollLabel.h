//
//  JYScrollLabel.h
//  test
//
//  Created by pjy on 2019/2/27.
//  Copyright © 2019 pjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYScrollLabel : UIView

@property (nonatomic, copy) NSArray *texts;

@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic) NSTimeInterval intervals;
@property (nonatomic) NSTimeInterval animateDuration;

@property (nonatomic, copy) void(^labelTapedAtIndex)(NSInteger index);

- (instancetype)initWithTexts:(NSArray *)texts;

- (void)startScroll;
- (void)stopScroll;

@end

