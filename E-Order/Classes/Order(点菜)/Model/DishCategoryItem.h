//
//  dishCatagoryItem.h
//  E-Order
//
//  Created by 杨卢青 on 16/5/6.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DishCategoryItem : NSObject
/**
 *  菜品分类ID
 */
@property (nonatomic, copy) NSString *category_id;
/**
 *  分类名
 */
@property (nonatomic, copy) NSString *name;
/**
 *  parent_id
 */
@property (nonatomic, copy) NSString *parent_id;
/**
 *  company_id
 */
@property (nonatomic, copy) NSString *company_id;
/**
 *  子分类 字典数组
 */
@property (nonatomic, copy) NSArray *child;
/**
 *  是否是展开cell状态
 */
@property (nonatomic ,assign ,getter=isSpread)BOOL spreadStatus;
/**
 *  当前是否被选中
 */
@property (nonatomic ,assign ,getter=isSelected)BOOL selectedStatus;

@end
