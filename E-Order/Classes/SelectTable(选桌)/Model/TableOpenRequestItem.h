//
//  TableOpenRequestItem.h
//  E-Order
//
//  Created by 杨卢青 on 16/5/6.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableOpenRequestItem : NSObject
/**
 *  桌位id
 */
@property (nonatomic, copy)NSString *tableid;
/**
 *  人数
 */
@property (nonatomic, copy)NSString *count;
/**
 *  服务员
 */
@property (nonatomic, copy)NSString *waiter;
/**
 *  开桌密码
 */
@property (nonatomic, copy)NSString *password;
@end
