//
//  DishSubPeiTaoItem.h
//  E-Order
//
//  Created by 杨卢青 on 16/5/11.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  配套
 */
@interface DishSubPeiTaoItem : NSObject
/**
 *  garnish_id
 */
@property (nonatomic, copy) NSString *garnish_id;
/**
 *  配套名字
 */
@property (nonatomic, copy) NSString *name;
/**
 *  配套价格
 */
@property (nonatomic, copy) NSString *price;
/**
 *  配套组_id
 */
@property (nonatomic, copy) NSString *supporting_id;
/**count*/
@property (nonatomic, assign) NSInteger peitaoCount;
@end