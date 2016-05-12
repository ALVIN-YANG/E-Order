//
//  DishSpecialOrderItem.h
//  E-Order
//
//  Created by 杨卢青 on 16/5/10.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DishSpecialOrderItem : NSObject
/**
 *  公司名
 */
@property (nonatomic, copy) NSString *company_id;
/**
 *  菜品名称
 */
@property (nonatomic, copy) NSString *dish_id;
/**
 *  label_id
 */
@property (nonatomic, copy) NSString *label_id;
/**
 *  配套名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  价格
 */
@property (nonatomic, copy) NSString *price;
/**是否被选中*/
@property (nonatomic ,assign ,getter=isSelected)BOOL selectedStatus;
@end
