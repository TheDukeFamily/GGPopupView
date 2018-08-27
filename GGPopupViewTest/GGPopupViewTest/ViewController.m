//
//  ViewController.m
//  GGPlayGroundDemo
//
//  Created by Mac on 2018/8/27.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import "ViewController.h"
#import "GGPopupView.h"
#import "GGPopupInnerView.h"
#import "CNPPopupController.h"


@interface ViewController ()<CNPPopupControllerDelegate>

@property (nonatomic, strong) CNPPopupController *popupController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"练习Demo";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-  (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
/**  自定义  */
- (IBAction)autoTest:(id)sender {
    [self showPopView];
}

/** 第三方 */
- (IBAction)threeTest:(id)sender {
    [self showPopupCentered];
}

- (void)showPopView{
    GGPopupInnerView *popInnerView = [GGPopupInnerView defaultPopupView];
    popInnerView.parentViewController = self;
    popInnerView.selIndex = 0;
    popInnerView.contents = @[@"斗鱼TV",@"虎牙TV",@"战旗TV",@"全民TV",@"龙珠TV",@"企鹅TV"];
    [popInnerView setSeletCompletion:^(NSString *content, NSInteger index) {
        NSLog(@"标题：%@-----下标：%ld",content,index);
    }];
    GGPopupViewAnimationSlide *animation = [[GGPopupViewAnimationSlide alloc] init];
    animation.type = GGPopupViewAnimationSlideTypeBottomBottom;
    [self gg_presentPopupView:popInnerView animation:animation backgroundClickable:YES dismissed:^{
        NSLog(@"动画结束");
    }];
}



-(void)showPopupCentered {
    [self showPopupWithStyle:CNPPopupStyleCentered];
}


- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle{
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"提示!" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:@"这是你的图片" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineTwo = [[NSAttributedString alloc] initWithString:@"爱仕达哈哈啥流口水" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0], NSParagraphStyleAttributeName : paragraphStyle}];
    
    CNPPopupButton *button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    button.layer.cornerRadius = 4;
    button.selectionHandler = ^(CNPPopupButton *button){
        [self.popupController dismissPopupControllerAnimated:YES];
        NSLog(@"Block for button: %@", button.titleLabel.text);
    };
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = title;
    
    UILabel *lineOneLabel = [[UILabel alloc] init];
    lineOneLabel.numberOfLines = 0;
    lineOneLabel.attributedText = lineOne;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lufei"]];
    imageView.frame = CGRectMake(0, 0, 230, 120);
    
    UILabel *lineTwoLabel = [[UILabel alloc] init];
    lineTwoLabel.numberOfLines = 0;
    lineTwoLabel.attributedText = lineTwo;
    
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 55)];
    customView.backgroundColor = [UIColor lightGrayColor];
    
    UITextField *textFied = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 230, 35)];
    textFied.borderStyle = UITextBorderStyleRoundedRect;
    textFied.placeholder = @"按时打卡接口老!";
    [customView addSubview:textFied];
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel, lineOneLabel, imageView, lineTwoLabel, customView, button]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
}


#pragma mark - CNPPopupController Delegate

- (void)popupController:(CNPPopupController *)controller didDismissWithButtonTitle:(NSString *)title {
    NSLog(@"Dismissed with button title: %@", title);
}

- (void)popupControllerDidPresent:(CNPPopupController *)controller {
    NSLog(@"Popup controller presented.");
}

@end
