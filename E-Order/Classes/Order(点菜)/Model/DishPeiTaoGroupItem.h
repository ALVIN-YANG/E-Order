//
//  DishPeiTaoItem.h
//  E-Order
//
//  Created by 杨卢青 on 16/5/11.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>





/**
 *  配套组
 */
@interface DishPeiTaoGroupItem : NSObject
/**
 *  配套头名
 */
@property (nonatomic, copy) NSString *name;
/**
 *  配套id
 */
@property (nonatomic, copy) NSString *id;
/**
 *  DishSubPeiTaoItem 数组
 */
@property (nonatomic, copy) NSMutableArray *arr;
@end
