//
//  DishDetailCell.h
//  E-Order
//
//  Created by 杨卢青 on 16/5/6.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DishBriefItem, DishBriefCell;
@protocol DishBriefCellDelegate <NSObject>

- (void)clickDishAddButton:(DishBriefCell *)cell;
- (void)clickDishMinusButton:(DishBriefCell *)cell;

@end

@interface DishBriefCell : UICollectionViewCell

@property (nonatomic, strong) DishBriefItem *item;

//+
@property (weak, nonatomic) IBOutlet UIButton *addButton;

//代理
@property (nonatomic, weak) id<DishBriefCellDelegate> delegate;
@end
