//
//  DishDetailView.h
//  E-Order
//
//  Created by 杨卢青 on 16/5/10.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DishDetailView,DishBriefItem;
@protocol DishDetailViewDelegate <NSObject>

- (void)clickCancelButtonWithItem:(DishBriefItem *)item;

@end
@interface DishDetailView : UIView
/**
 *  菜品数据模型
 */
@property (nonatomic, strong) DishBriefItem *item;

@property (nonatomic, weak)id<DishDetailViewDelegate> delegate;
@end
