//
//  SpecialOrderCell.m
//  E-Order
//
//  Created by 杨卢青 on 16/5/10.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "SpecialOrderCell.h"
#import "DishSpecialOrderItem.h"

@implementation SpecialOrderCell

- (void)setItem:(DishSpecialOrderItem *)item
{
    _item =item;
    if (_item.selectedStatus) {
        [self setSelected:YES];
    }
    UIView * view = [[UIView alloc] initWithFrame:self.contentView.bounds];
    view.backgroundColor = UIColorFromHex(0xEC7724);
    self.selectedBackgroundView = view;
    
    if (0 == item.price.integerValue) {
        self.titleLabel.text = item.name;
    }else {
        self.titleLabel.text = [NSString stringWithFormat:@"%@:%@元", item.name, item.price];
    }
    self.layer.borderColor = UIColorFromHex(0xF1EBE1).CGColor;
    self.layer.borderWidth = 1;
}
@end
