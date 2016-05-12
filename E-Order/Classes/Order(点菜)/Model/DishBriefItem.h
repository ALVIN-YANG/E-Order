//
//  dishDetailItem.h
//  E-Order
//
//  Created by 杨卢青 on 16/5/6.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DishBriefItem : NSObject
/**
 *  菜品ID
 */
@property (nonatomic, copy) NSString *dish_id;
/**
 *  菜品分类名称
 */
@property (nonatomic, copy) NSString *catename;
/**
 *  菜名
 */
@property (nonatomic, copy) NSString *name;
/**
 *  菜品介绍
 */
@property (nonatomic, copy) NSString *content;
/**
 *  配套
 */
@property (nonatomic, copy) NSArray *peitao;
/**
 *  价格
 */
@property (nonatomic, copy) NSString *price;
/**
 *  特殊要求
 */
@property (nonatomic, copy) NSArray *teshuyaoqiu;
/**
 *  菜品图片后缀
 */
@property (nonatomic, copy) NSString *image;
/**
 *  菜品订单数量
 */
@property (nonatomic, assign) NSInteger orderCount;


@end
