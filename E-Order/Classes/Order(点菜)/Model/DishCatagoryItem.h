//
//  dishCatagoryItem.h
//  E-Order
//
//  Created by 杨卢青 on 16/5/6.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DishCatagoryItem : NSObject
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

@end
