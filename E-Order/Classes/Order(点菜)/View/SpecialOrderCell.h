//
//  SpecialOrderCell.h
//  E-Order
//
//  Created by 杨卢青 on 16/5/10.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DishSpecialOrderItem;
@interface SpecialOrderCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) DishSpecialOrderItem *item;
@end
