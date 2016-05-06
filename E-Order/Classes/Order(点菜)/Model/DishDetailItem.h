//
//  dishDetailItem.h
//  E-Order
//
//  Created by 杨卢青 on 16/5/6.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DishDetailItem : NSObject
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
 *  价格
 */
@property (nonatomic, copy) NSString *price;
/**
 *  菜品图片后缀
 */
@property (nonatomic, copy) NSString *image;

@end
