//
//  DishPeitaoCell.m
//  E-Order
//
//  Created by 杨卢青 on 16/5/11.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "DishPeitaoCell.h"
#import "DishSubPeiTaoItem.h"

@interface DishPeitaoCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end
@implementation DishPeitaoCell

- (void)setItem:(DishSubPeiTaoItem *)item
{
    _item = item;
    UIColor *color = UIColorFromHex(0xEAEAE1);
    self.contentView.layer.borderColor = color.CGColor;
    self.contentView.layer.borderWidth = 1;
    self.nameLabel.text = item.name;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", item.price];
  
    self.countLabel.text = [NSString stringWithFormat:@"%ld", item.peitaoCount];
    _countLabel.layer.borderColor = color.CGColor;
    _countLabel.layer.borderWidth = 1;
    
    self.addButton.layer.borderColor = color.CGColor;
    self.addButton.layer.borderWidth = 1;
    
}

- (IBAction)addButtonClick:(id)sender {
    //修改模型
    _item.peitaoCount++;
    _countLabel.text = [NSString stringWithFormat:@"%ld", _item.peitaoCount];
    if ([self.delegate respondsToSelector:@selector(addButtonFromPeitaoCellClick:)]) {
        [self.delegate addButtonFromPeitaoCellClick:self];
    }
}
- (IBAction)minusButtonClick:(id)sender {
    //修改模型
    if (0 == _item.peitaoCount) {
        return;
    }
    _item.peitaoCount--;
    _countLabel.text = [NSString stringWithFormat:@"%ld", _item.peitaoCount];
    if ([self.delegate respondsToSelector:@selector(minusButtonFromPeitaoCellClick:)]) {
        [self.delegate minusButtonFromPeitaoCellClick:self];
    }
}


@end
