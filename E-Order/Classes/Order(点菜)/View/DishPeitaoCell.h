//
//  DishPeitaoCell.h
//  E-Order
//
//  Created by 杨卢青 on 16/5/11.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DishSubPeiTaoItem;
@class DishPeitaoCell;
@protocol DishPeitaoCellDelegate <NSObject>

- (void)addButtonFromPeitaoCellClick:(DishPeitaoCell *)cell;
- (void)minusButtonFromPeitaoCellClick:(DishPeitaoCell *)cell;

@end
@interface DishPeitaoCell : UICollectionViewCell

@property (nonatomic, strong) DishSubPeiTaoItem *item;

@property (nonatomic, weak) id<DishPeitaoCellDelegate> delegate;
@end
