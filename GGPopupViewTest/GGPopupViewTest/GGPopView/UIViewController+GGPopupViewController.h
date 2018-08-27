//
//  UIViewController+GGPopupViewController.h
//  GGPlayGroundDemo
//
//  Created by Mac on 2018/8/27.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GGPopupAnimation <NSObject>
@required

- (void)showView:(UIView *)popupView overlayView:(UIView *)overlayView;

- (void)dismissView:(UIView*)popupView overlayView:(UIView*)overlayView completion:(void (^)(void))completion;

@end

@interface UIViewController (GGPopupViewController)

@property (nonatomic, strong ,readonly) UIView *GGPopupView;
@property (nonatomic, strong, readonly) UIView *GGOverlayView;
@property (nonatomic, strong, readonly) id <GGPopupAnimation> GGPopupAnimation;

- (void)gg_presentPopupView:(UIView *)popupView animation:(id<GGPopupAnimation>)animation;
- (void)gg_presentPopupView:(UIView *)popupView animation:(id<GGPopupAnimation>)animation dismissed:(void(^)(void))dismissed;

- (void)gg_presentPopupView:(UIView *)popupView animation:(id<GGPopupAnimation>)animation backgroundClickable:(BOOL)clickable;
- (void)gg_presentPopupView:(UIView *)popupView animation:(id<GGPopupAnimation>)animation backgroundClickable:(BOOL)clickable dismissed:(void(^)(void))dismissed;

- (void)gg_dismissPopupView;
- (void)gg_dismissPopupViewWithanimation:(id<GGPopupAnimation>)animation;

@end
