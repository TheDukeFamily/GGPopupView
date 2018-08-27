//
//  UIViewController+GGPopupViewController.m
//  GGPlayGroundDemo
//
//  Created by Mac on 2018/8/27.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import "UIViewController+GGPopupViewController.h"
#import <objc/message.h>
#import "GGPopupBackgroundView.h"

#define kGGPopupView @"kGGPopupView"
#define kGGOverlayView @"kGGOverlayView"
#define kGGPopupViewDismissedBlock @"kGGPopupViewDismissedBlock"
#define KGGPopupAnimation @"KGGPopupAnimation"
#define kGGPopupViewController @"kGGPopupViewController"

static NSInteger const  kGGPopupViewTag = 8002;
static NSInteger const  kGGOverlayViewTag = 8003;

@interface UIView (GGPopupViewControllerPrivate)

@property (nonatomic, weak , readwrite) UIViewController *GGPopupViewController;


@end

@interface UIViewController (GGPopupViewControllerPrivate)
@property (nonatomic, retain) UIView *GGPopupView;
@property (nonatomic, retain) UIView *GGOverlayView;
@property (nonatomic, copy) void(^GGDismissCallback)(void);
@property (nonatomic, retain) id<GGPopupAnimation> popupAnimation;
- (UIView*)topView;
@end


@implementation UIViewController (GGPopupViewController)

- (void)gg_presentPopupView:(UIView *)popupView animation:(id<GGPopupAnimation>)animation{
    [self _presentPopupView:popupView animation:animation backgroundClickable:YES dismissed:nil];
}

- (void)gg_presentPopupView:(UIView *)popupView animation:(id<GGPopupAnimation>)animation dismissed:(void(^)(void))dismissed{
    [self _presentPopupView:popupView animation:animation backgroundClickable:YES dismissed:dismissed];
}

- (void)gg_presentPopupView:(UIView *)popupView animation:(id<GGPopupAnimation>)animation backgroundClickable:(BOOL)clickable{
    [self _presentPopupView:popupView animation:animation backgroundClickable:clickable dismissed:nil];
}

- (void)gg_presentPopupView:(UIView *)popupView animation:(id<GGPopupAnimation>)animation backgroundClickable:(BOOL)clickable dismissed:(void(^)(void))dismissed{
    [self _presentPopupView:popupView animation:animation backgroundClickable:clickable dismissed:dismissed];
}

- (void)gg_dismissPopupView{
    [self _dismissPopupViewWithanimation:nil];
}

- (void)gg_dismissPopupViewWithanimation:(id<GGPopupAnimation>)animation{
    [self _dismissPopupViewWithanimation:animation];
}


#pragma mark - inline property

- (UIView *)GGPopupView{
    return objc_getAssociatedObject(self, kGGPopupView);
}

- (void)setGGPopupView:(UIView *)GGPopupView{
    objc_setAssociatedObject(self, kGGPopupView, GGPopupView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)GGOverlayView{
    return objc_getAssociatedObject(self, kGGOverlayView);
}

- (void)setGGOverlayView:(UIView *)GGOverlayView{
    objc_setAssociatedObject(self, kGGOverlayView, GGOverlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void))GGDismissCallback{
    return objc_getAssociatedObject(self, kGGPopupViewDismissedBlock);
}

- (void)setGGDismissCallback:(void (^)(void))GGDismissCallback{
    return objc_setAssociatedObject(self, kGGPopupViewDismissedBlock, GGDismissCallback, OBJC_ASSOCIATION_COPY);
}

- (id<GGPopupAnimation>)GGPopupAnimation{
   return objc_getAssociatedObject(self, KGGPopupAnimation);
}

- (void)setGGPopupAnimation:(id<GGPopupAnimation>)GGPopupAnimation{
    return objc_setAssociatedObject(self, KGGPopupAnimation, GGPopupAnimation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark = viewHandle

- (void)_presentPopupView:(UIView *)popupView animation:(id<GGPopupAnimation>)animation backgroundClickable:(BOOL)clickable dismissed:(void (^)(void))dismissed{
    
    if ([self.GGOverlayView.subviews containsObject:popupView]) return;
    
    if (self.GGOverlayView && self.GGOverlayView.subviews.count>1) {
        [self _dismissPopupViewWithanimation:nil];
    }
    
    self.GGPopupView  = nil;
    self.GGPopupView = popupView;
    self.GGPopupAnimation = nil;
    self.GGPopupAnimation = animation;
    
    UIView *sourceView = [self _gg_topView];
    
    popupView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    popupView.tag = kGGPopupViewTag;
    popupView.layer.shadowPath = [UIBezierPath bezierPathWithRect:popupView.bounds].CGPath;
    popupView.layer.masksToBounds = NO;
    popupView.layer.shadowOffset = CGSizeMake(5, 5);
    popupView.layer.shadowRadius = 5;
    popupView.layer.shadowOpacity = 0.5;
    popupView.layer.shouldRasterize = YES;
    popupView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    if(self.GGOverlayView == nil){
        UIView *overlayView = [[UIView alloc] initWithFrame:sourceView.bounds];
        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayView.tag = kGGOverlayViewTag;
        overlayView.backgroundColor = [UIColor clearColor];
        
        UIView *backgroundView = [[GGPopupBackgroundView alloc] initWithFrame:sourceView.bounds];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        backgroundView.backgroundColor = [UIColor clearColor];
        [overlayView addSubview:backgroundView];
        
        if (clickable) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gg_dismissPopupView)];
            [backgroundView addGestureRecognizer:tap];
        }
        self.GGOverlayView = overlayView;
    }
    
    [self.GGOverlayView addSubview:popupView];
    [sourceView addSubview:self.GGOverlayView];
    
    self.GGOverlayView.alpha = 1.0f;
    popupView.center = self.GGOverlayView.center;
    if (animation) {
        [animation showView:popupView overlayView:self.GGOverlayView];
    }
    
    [self setGGDismissCallback:dismissed];
}

- (void)_dismissPopupViewWithanimation:(id<GGPopupAnimation>)animation{
    if (animation) {
        [animation dismissView:self.GGPopupView overlayView:self.GGOverlayView completion:^{
            [self.GGOverlayView removeFromSuperview];
            [self.GGPopupView removeFromSuperview];
            self.GGPopupView = nil;
            self.GGOverlayView = nil;
            
            id dismissed = [self GGDismissCallback];
            if (dismissed != nil) {
                ((void(^)(void))dismissed)();
                [self setGGDismissCallback:nil];
                
            }
        }];
    }else{
        [self.GGOverlayView removeFromSuperview];
        [self.GGPopupView removeFromSuperview];
        self.GGPopupView = nil;
        self.GGPopupAnimation = nil;
        
        id dismissed = [self GGDismissCallback];
        if (dismissed != nil){
            ((void(^)(void))dismissed)();
            [self setGGDismissCallback:nil];
        }
    }
}


-(UIView*)_gg_topView {
    UIViewController *recentView = self;
    
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}

@end

#pragma mark - UIView+JXPopupView
@implementation UIView (GGPopupViewController)

- (UIViewController *)GGPopupViewController{
    return objc_getAssociatedObject(self, kGGPopupViewController);
}

- (void)setGGPopupViewController:(UIViewController *)GGPopupViewController{
    objc_setAssociatedObject(self, kGGPopupViewController, GGPopupViewController, OBJC_ASSOCIATION_ASSIGN);
}

@end
