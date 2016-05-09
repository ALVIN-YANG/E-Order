//
//  DishDetailCell.h
//  E-Order
//
//  Created by 杨卢青 on 16/5/6.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DishDetailItem, DishDetailCell;
@protocol DishDetailCellDelegate <NSObject>

- (void)clickDishAddButton:(DishDetailCell *)cell;
- (void)clickDishMinusButton:(DishDetailCell *)cell;

@end

@interface DishDetailCell : UICollectionViewCell

@property (nonatomic, strong) DishDetailItem *item;

//+
@property (weak, nonatomic) IBOutlet UIButton *addButton;

//代理
@property (nonatomic, weak) id<DishDetailCellDelegate> delegate;
@end
