//
//  TableCategoryItem.h
//  E-Order
//
//  Created by 杨卢青 on 16/5/5.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableCategoryItem : NSObject

/**
 *  饭店ID
 */
@property (nonatomic, copy)NSString * company_id;
/**
 *  楼号名
 */
@property (nonatomic, copy)NSString * name;
/**
 *  楼号ID
 */
@property (nonatomic, copy)NSString * table_category_id;
@end
