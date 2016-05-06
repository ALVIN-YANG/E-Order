//
//  OrderViewController.m
//  E-Order
//
//  Created by 杨卢青 on 16/5/6.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "OrderViewController.h"
//菜品分类数据模型
#import "DishCatagoryItem.h"
//详细菜品数据模型
#import "DishDetailItem.h"
#import <AFNetworking.h>

@interface OrderViewController ()

//请求管理
@property (nonatomic, strong) AFHTTPSessionManager *mgr;

//菜品分类模型数组
@property (nonatomic, strong) NSArray *DishCatagoryArray;
//详细菜品模型数据
@property (nonatomic, strong) NSArray *DishDetailArray;
@end

@implementation OrderViewController
#pragma mark - 初始化懒加载
- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        _mgr = [AFHTTPSessionManager manager];
    }
    return _mgr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //请求菜品分类
    [self requestDishCatagoryData];
}

#pragma mark - Helpers
- (void)requestDishCatagoryData
{
    
}

@end
