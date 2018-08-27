//
//  GGPopupInnerView.h
//  GGPlayGroundDemo
//
//  Created by Mac on 2018/8/27.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GGPopupInnerViewSelectedBlock)(NSString *,NSInteger);

@interface GGPopupInnerView : UIView

@property (nonatomic, weak) UIViewController *parentViewController;

@property (nonatomic, assign) NSInteger selIndex;

@property (nonatomic, copy) GGPopupInnerViewSelectedBlock seletCompletion;

@property (nonatomic, strong) NSArray <NSString *> *contents;

+ (instancetype)defaultPopupView;

@end
