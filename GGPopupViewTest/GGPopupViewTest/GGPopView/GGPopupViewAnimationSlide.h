//
//  JXPopupViewAnimationSlide.h
//  GGPlayGroundDemo
//
//  Created by Mac on 2018/8/27.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+GGPopupViewController.h"

typedef NS_ENUM(NSUInteger, GGPopupViewAnimationSlideType) {
    GGPopupViewAnimationSlideTypeBottomTop,
    GGPopupViewAnimationSlideTypeBottomBottom,
    GGPopupViewAnimationSlideTypeTopTop,
    GGPopupViewAnimationSlideTypeTopBottom,
    GGPopupViewAnimationSlideTypeLeftLeft,
    GGPopupViewAnimationSlideTypeLeftRight,
    GGPopupViewAnimationSlideTypeRightLeft,
    GGPopupViewAnimationSlideTypeRightRight,
};

@interface GGPopupViewAnimationSlide : NSObject<GGPopupAnimation>

@property (nonatomic,assign)GGPopupViewAnimationSlideType type;

@end
