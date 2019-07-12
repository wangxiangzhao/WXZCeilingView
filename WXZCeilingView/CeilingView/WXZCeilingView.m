//
//  WXZCeilingView.m
//  WXZCeilingView
//
//  Created by 王向召 on 2019/7/12.
//  Copyright © 2019 王向召. All rights reserved.
//

#import "WXZCeilingView.h"

static NSString * const kKVOKeyPath = @"contentOffset";
static NSString * const kKVODecelerating = @"decelerating";

@interface WXZScrollView : UIScrollView <UIGestureRecognizerDelegate>

@end

@implementation WXZScrollView

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

@interface WXZCeilingView () <UIScrollViewDelegate>

@property (nonatomic, strong) WXZScrollView *mainScrollView;
//@property (nonatomic, strong) UIScrollView *bodyScrollView;

@end

@implementation WXZCeilingView

- (instancetype)initWithFrame:(CGRect)frame
                     bodyView:(UIScrollView *)bodyView
                   headerView:(UIView *)headerView
                   ceilingBar:(UIView *)ceilingBar {
    self = [super initWithFrame:frame];
    if (self) {
        _bodyView = bodyView;
        _headerView = headerView;
        _ceilingBar = ceilingBar;
        [self kvoBodyView];
        [self loadSubviews];
    }
    return self;
}

+ (instancetype)viewWithFrame:(CGRect)frame
                     bodyView:(UIScrollView *)bodyView
                   headerView:(UIView *)headerView
                   ceilingBar:(UIView *)ceilingBar {
    return [[WXZCeilingView alloc] initWithFrame:frame bodyView:bodyView headerView:headerView ceilingBar:ceilingBar];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = _bodyView.contentOffset;
    if (offset.y > 0) {
        scrollView.contentOffset = CGPointMake(0, self.headerView.frame.size.height);
        [self updateBodyViewFrame];
    } else {
        offset.y = 0;
        _bodyView.contentOffset = offset;
    }
}

#pragma mark - kvo action

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    CGPoint newValue = [change[NSKeyValueChangeNewKey] CGPointValue];
    CGPoint oldValue = [change[NSKeyValueChangeOldKey] CGPointValue];
    if (CGPointEqualToPoint(newValue, oldValue)) {
        return;
    }
    [self bodyViewDidScroll:_bodyView];
}

#pragma mark - publics

- (void)bodyViewDidScroll:(UIScrollView *)scrollView {
    if (_mainScrollView.contentOffset.y < _headerView.frame.size.height && _mainScrollView.contentOffset.y > 0) {
        CGPoint offset = scrollView.contentOffset;
        if (offset.y == 0) {
            return;
        }
        offset.y = 0;
        scrollView.contentOffset = offset;
    } else if (_mainScrollView.contentOffset.y > CGRectGetHeight(_headerView.frame)) {
        [self ceilingTop];
    }
}

#pragma mark - publics

- (void)ceilingTop {
    [self setCeilingOffset];
    [self updateBodyViewFrame];
}

#pragma mark - privates

- (void)kvoBodyView {
    [_bodyView addObserver:self forKeyPath:kKVOKeyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)removeBodyViewKvo {
    [_bodyView removeObserver:self forKeyPath:kKVOKeyPath];
}

- (void)updateBodyViewFrame {
    CGRect frame = _bodyView.frame;
    frame.size.height = CGRectGetHeight(self.frame) - CGRectGetHeight(_ceilingBar.frame);
    _bodyView.frame = frame;
}

- (void)setCeilingOffset {
    CGPoint offset = _mainScrollView.contentOffset;
    offset.y = CGRectGetHeight(_headerView.frame);
    _mainScrollView.contentOffset = offset;
}

#pragma mark - load subviews

- (void)loadSubviews {
    _mainScrollView = [[WXZScrollView alloc] initWithFrame:self.bounds];
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_mainScrollView];
    [_mainScrollView addSubview:_headerView];
    [_mainScrollView addSubview:_ceilingBar];
    
    [_mainScrollView addSubview:_bodyView];
    
    _mainScrollView.contentSize = CGSizeMake(0, CGRectGetHeight(_mainScrollView.frame) + CGRectGetHeight(_headerView.frame));
    _ceilingBar.frame = CGRectMake(0, CGRectGetMaxY(_headerView.frame), CGRectGetWidth(_ceilingBar.frame), CGRectGetHeight(_ceilingBar.frame));
    _bodyView.frame = CGRectMake(0, CGRectGetMaxY(_ceilingBar.frame), CGRectGetWidth(_bodyView.frame), CGRectGetHeight(_bodyView.frame));
}

- (void)dealloc {
    [self removeBodyViewKvo];
}

@end
