//
//  DishDetailCell.m
//  E-Order
//
//  Created by 杨卢青 on 16/5/6.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "DishBriefCell.h"
#import "DishBriefItem.h"
#import <UIImageView+WebCache.h>

@interface DishBriefCell()
@property (weak, nonatomic) IBOutlet UIImageView *dishImageView;
@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

//单位
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

//-
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
//6
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@end
@implementation DishBriefCell

//接收数据, 来到setter
- (void)setItem:(DishBriefItem *)item
{
    _item = item;
    self.dishNameLabel.text = item.name;
    [self.dishImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DCBaseImage, item.image]]];
    self.priceLabel.text = item.price;
    self.countLabel.text = [NSString stringWithFormat:@"%ld", _item.orderCount];
    //按钮逻辑
    if (item.orderCount > 0) {
        [self.minusButton setHidden:NO];
        [self.countLabel setHidden:NO];
    } else {
        [self.minusButton setHidden:YES];
        [self.countLabel setHidden:YES];
    }
}

- (IBAction)addButtonClick:(id)sender {
    //修改模型
    _item.orderCount++;
    _countLabel.text = [NSString stringWithFormat:@"%ld", _item.orderCount];
    _minusButton.hidden = NO;
    _countLabel.hidden = NO;
    
    // 通知代理（调用代理的方法）
    if ([self.delegate respondsToSelector:@selector(clickDishAddButton:)]) {
        [self.delegate clickDishAddButton:self];
    }
}
- (IBAction)minusButton:(id)sender {
    
    _item.orderCount--;
    _countLabel.text = [NSString stringWithFormat:@"%ld", _item.orderCount];
    
    if (_item.orderCount == 0) {
        _minusButton.hidden = YES;
        _countLabel.hidden = YES;
    }

    
    if ([self.delegate respondsToSelector:@selector(clickDishMinusButton:)]) {
        [self.delegate clickDishMinusButton:self];
    }
}
@end
