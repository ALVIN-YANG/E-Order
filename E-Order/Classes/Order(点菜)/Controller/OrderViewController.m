//
//  OrderViewController.m
//  E-Order
//
//  Created by 杨卢青 on 16/5/6.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "OrderViewController.h"
//菜品分类数据模型
#import "DishCategoryItem.h"
//详细菜品数据模型
#import "DishDetailItem.h"
//cell
#import "DishCategoryCell.h"
#import "DishDetailCell.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>

@interface OrderViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//请求管理
@property (nonatomic, strong) AFHTTPSessionManager *mgr;

//菜品分类模型数组
@property (nonatomic, strong) NSArray *dishCategoryArray;
//详细菜品模型数据
@property (nonatomic, strong) NSArray *dishDetailArray;
@end


//Identifier
static NSString * const CellIDforCategory = @"tableCell";
static NSString * const CellIDforDetail = @"CollectionCell";
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
    
    //设置菜品分类Table
    [self setupTableView];
}

#pragma mark - Helpers
- (void)requestDishCatagoryData
{
    NSString *followURL = @"/Home/user/dishcategory";
    NSString *askingURL = [NSString stringWithFormat:@"%@%@", DCBaseUrl, followURL];
    [self.mgr POST:askingURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"\n菜品分类数据:\n%@", responseObject);
        
        //得到菜品分类数据
        self.dishCategoryArray = [DishCategoryItem mj_objectArrayWithKeyValuesArray:responseObject];
        //刷新tableView
        [self.tableView reloadData];
        
        //请求根据第一个菜品分类模型的id 请求该分类对应的菜品数据
        DishCategoryItem *firstItem = self.dishCategoryArray[0];
        [self requestTableStatusData:firstItem.category_id];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\nerror:\n%@", error);
        [SVProgressHUD showErrorWithStatus:@"获取桌位信息失败\n请稍后尝试"];
    }];
}

/**
 *  根据菜品分类获取详细菜品数据
 *
 *  @param categoryID 菜品分类ID
 */
- (void)requestTableStatusData:(NSString *)categoryID
{
    
}

/**
 *  设置菜品分类Tableview
 */
- (void)setupTableView
{
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DishCategoryCell" bundle:nil] forCellReuseIdentifier:CellIDforCategory];
    
    [self.view addSubview:self.tableView];
}

/**
 * 已点菜单点击
 */
- (IBAction)alreadyDishButtonClick:(id)sender {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dishCategoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DishCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIDforCategory];
    DishCategoryItem *item = self.dishCategoryArray[indexPath.row];
    cell.CategoryNameLabel.text = item.name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableView.height/12;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //请求对应collection数据
    DishCategoryItem *item = self.dishCategoryArray[indexPath.row];
    [self requestTableStatusData:item.category_id];
}
@end
