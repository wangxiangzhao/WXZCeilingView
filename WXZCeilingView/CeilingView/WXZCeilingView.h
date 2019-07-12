//
//  WXZCeilingView.h
//  WXZCeilingView
//
//  Created by 王向召 on 2019/7/12.
//  Copyright © 2019 王向召. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXZCeilingView : UIView

+ (instancetype)viewWithFrame:(CGRect)frame
                     bodyView:(UIScrollView *)bodyView
                   headerView:(UIView *)headerView
                   ceilingBar:(UIView *)ceilingBar;

@property (nonatomic, strong, readonly) UIScrollView *bodyView;
@property (nonatomic, strong, readonly) UIView *headerView;
@property (nonatomic, strong, readonly) UIView *ceilingBar;

- (void)ceilingTop;

@end

NS_ASSUME_NONNULL_END
