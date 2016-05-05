//
//  SelectTebleCellTableViewCell.m
//  E-Order
//
//  Created by 杨卢青 on 16/5/5.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "SelectTebleCell.h"

@interface SelectTebleCell()

@end
@implementation SelectTebleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.floorNumLabel.textColor = [UIColor whiteColor];
        self.sorLabel.textColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor orangeColor];
    }else{
        self.floorNumLabel.textColor = [UIColor darkGrayColor];
        self.sorLabel.textColor = [UIColor darkGrayColor];
        self.contentView.backgroundColor = Color(249, 238, 204);
    }
}

@end
