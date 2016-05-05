//
//  TableStatusItem.h
//  E-Order
//
//  Created by 杨卢青 on 16/5/5.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableStatusItem : NSObject
/**
 *  楼号
 */
@property (nonatomic, copy)NSString *catename;
/**
 *  桌名
 */
@property (nonatomic, copy)NSString *number;
/**
 *  状态,是否有人
 */
@property (nonatomic, copy)NSString *status;
/**
 *  桌子id
 */
@property (nonatomic, copy)NSString *table_id;
@end
