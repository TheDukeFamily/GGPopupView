//
//  GGPopupInnerView.m
//  GGPlayGroundDemo
//
//  Created by Mac on 2018/8/27.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import "GGPopupInnerView.h"
#import "GGPopupView.h"
#import "UIView+Extension.h"

@interface GGPopupInnerViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *contentLable;
@property (nonatomic, strong) UIButton *selectedButton;
@end

@implementation GGPopupInnerViewCell

- (UILabel *)contentLable{
    if (!_contentLable) {
        _contentLable = [[UILabel alloc] init];
        _contentLable.font = [UIFont systemFontOfSize:15];
        _contentLable.text = @"测试";
    }
    return _contentLable;
}

- (UIButton *)selectedButton{
    if (!_selectedButton) {
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedButton setImage:[UIImage imageNamed:@"off_choose"] forState:UIControlStateNormal];
        [_selectedButton setImage:[UIImage imageNamed:@"no_choose"] forState:UIControlStateSelected];
        _selectedButton.adjustsImageWhenHighlighted = NO;
        _selectedButton.adjustsImageWhenDisabled = NO;
        _selectedButton.userInteractionEnabled = NO;
        
    }
    return _selectedButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.contentLable];
        [self.contentView addSubview:self.selectedButton];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat btnWH = 15;
    self.selectedButton.frame = CGRectMake(10, (self.contentView.frame.size.height - btnWH) * 0.5, btnWH, btnWH);
    
    self.contentLable.frame = CGRectMake(CGRectGetMaxX(self.selectedButton.frame) + 10, 0, self.contentView.width - CGRectGetMaxX(self.selectedButton.frame) - 20, self.contentView.height);
}

@end

@interface GGPopupInnerView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GGPopupInnerView


- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[GGPopupInnerViewCell class] forCellReuseIdentifier:@"popCell"];
        _tableView.rowHeight = 44;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.layer.cornerRadius = 5;
        _tableView.layer.masksToBounds = YES;
        
    }
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews{
    self.tableView.frame = self.bounds;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contents.count == 0 ? 1 : self.contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GGPopupInnerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"popCell"];
    
    if (indexPath.row == self.selIndex) {
        cell.selectedButton.selected = YES;
    }
    
    if (self.contents.count) {
        cell.contentLable.text = self.contents[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GGPopupInnerViewCell *lastCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selIndex inSection:0]];
    lastCell.selectedButton.selected = NO;
    
    GGPopupInnerViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectedButton.selected = YES;
    
    // dismiss
    [_parentViewController gg_dismissPopupView];
    
    // callback
    if (self.seletCompletion) {
        self.seletCompletion(cell.contentLable.text,indexPath.row);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GGPopupInnerViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectedButton.selected = NO;
}

+ (instancetype)defaultPopupView{
    
    return [[GGPopupInnerView alloc]initWithFrame:CGRectMake(0, 0, 195, 210)];
}


@end
