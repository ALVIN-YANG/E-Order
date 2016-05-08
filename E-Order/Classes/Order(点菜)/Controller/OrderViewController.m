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
#import "DishSubCategoryCell.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>

@interface OrderViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//请求管理
@property (nonatomic, strong) AFHTTPSessionManager *mgr;

//菜品分类模型数组
@property (nonatomic, strong) NSMutableArray *dishCategoryArray;
//当前主分类菜品的子分类, 要插入到主分类里面, 记录主分类的index
@property (nonatomic, strong) NSMutableArray *dishSubCategoryArray;
//插入的range
@property (nonatomic, assign) NSRange addRange;
//删除的range
@property (nonatomic, assign) NSRange deleteRange;
//工具range
@property (nonatomic, assign) NSRange range;
//上次点击的index
@property (nonatomic, assign) NSInteger lastClickIndex;
//详细菜品模型数据
@property (nonatomic, strong) NSArray *dishDetailArray;

@end


//Identifier
static NSString * const CellIDforCategory = @"tableMainCell";
static NSString * const CellIDforSubCategory = @"tableChildCell";
static NSString * const CellIDforDetail = @"CollectionCell";
@implementation OrderViewController
#pragma mark - 初始化懒加载
- (NSMutableArray *)dishCategoryArray {
    if (!_dishCategoryArray) {
        _dishCategoryArray = [NSMutableArray array];
    }
    return _dishCategoryArray;
}

- (NSMutableArray *)dishSubCategoryArray {
    if (!_dishSubCategoryArray) {
        _dishSubCategoryArray = [NSMutableArray array];
    }
    return _dishSubCategoryArray;
}

- (NSArray *)dishDetailArray {
    if (!_dishDetailArray) {
        _dishDetailArray = [NSArray array];
    }
    return _dishDetailArray;
}

- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        _mgr = [AFHTTPSessionManager manager];
    }
    return _mgr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化属性
    [self initAttribute];
    //请求菜品分类
    [self requestDishCatagoryData];
    
    //设置菜品分类Table
    [self setupTableView];
}

- (void)initAttribute
{
    self.lastClickIndex = MAXFLOAT;
}

#pragma mark - Helpers
- (void)requestDishCatagoryData
{
    NSString *followURL = @"/Home/user/dishcategory";
    NSString *askingURL = [NSString stringWithFormat:@"%@%@", DCBaseUrl, followURL];
    [self.mgr POST:askingURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"\n菜品分类数据:\n%@", responseObject);
        
         [responseObject writeToFile:@"/Users/YLQ/Desktop/Eplist/菜品分类.plist" atomically:YES];
        //得到菜品分类数据
        self.dishCategoryArray = [DishCategoryItem mj_objectArrayWithKeyValuesArray:responseObject];
        
        //刷新tableView
        [self.tableView reloadData];
        
        //请求根据第一个菜品分类模型的id 请求该分类对应的菜品数据
        DishCategoryItem *firstItem = self.dishCategoryArray[0];
        [self requestDishDetailsData:firstItem.category_id];
        
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
- (void)requestDishDetailsData:(NSString *)categoryID
{
    NSString *followURL = @"/Home/user/categorydish";
    NSString *askingURL = [NSString stringWithFormat:@"%@%@", DCBaseUrl, followURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"categoryid"] = categoryID;
    [self.mgr POST:askingURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"\n对应菜品详细数据:\n%@", responseObject);
        
        [responseObject writeToFile:@"/Users/YLQ/Desktop/Eplist/分类对应菜品.plist" atomically:YES];
        //得到菜品分类数据
        self.dishDetailArray = [DishDetailItem mj_objectArrayWithKeyValuesArray:responseObject];
        
        //刷新collectionView
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\nerror:\n%@", error);
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"获取对应菜品信息失败\n请稍后尝试"]];
    }];

}

/**
 *  设置菜品分类Tableview
 */
- (void)setupTableView
{
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DishCategoryCell" bundle:nil] forCellReuseIdentifier:CellIDforCategory];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DishSubCategoryCell" bundle:nil] forCellReuseIdentifier:CellIDforSubCategory];
    
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
    DishCategoryItem *item = self.dishCategoryArray[indexPath.row];
    
    //主分类
    if (!item.parent_id.integerValue) {
        //创建主分类cell
        DishCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIDforCategory];
        cell.CategoryNameLabel.text = item.name;
        //没有子类的分类  没有箭头
        if (!item.child) {
            cell.sorLabel.hidden = YES;
        }
        //选中状态改变
        //为什么 cell类里的setSelected:animated:方法调用不起作用?
            if (item.isSelected) {
                cell.CategoryNameLabel.textColor = UIColorFromHex(0xFFFFFF);
                cell.sorLabel.textColor = UIColorFromHex(0xFFFFFF);
                cell.contentView.backgroundColor = UIColorFromHex(0xEC7624);
                cell.CategoryNameLabel.textColor = [UIColor blackColor];
                cell.sorLabel.textColor = [UIColor blackColor];
                cell.contentView.backgroundColor = [UIColor orangeColor];
        
                //箭头动画最终向上
            }else {
                cell.CategoryNameLabel.textColor = UIColorFromHex(0x130B04);
                cell.sorLabel.textColor = UIColorFromHex(0xFFFFFA);
                cell.contentView.backgroundColor = UIColorFromHex(0xFDF4E5);
        
                //动画箭头最终向下
            }
        return cell;
    }
    //子分类
    else {
        DishSubCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIDforSubCategory];
        cell.categoryNameLabel.text = item.name;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableView.height/12;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DishCategoryItem *item = self.dishCategoryArray[indexPath.row];
    //先请求对应collection数据
    [self requestDishDetailsData:item.category_id];
    //点击了子分类, 没有状态改变
    if (0 != item.parent_id.integerValue) {
        return;
    }
    
    //只能有一个分类被选中
    for (DishCategoryItem *model in self.dishCategoryArray) {
        model.selectedStatus = NO;
    }
    item.selectedStatus = YES;
    //点击已展开的主分类
    if (item.isSpread) {
        //移除展开的数据, 刷新UI
        self.dishSubCategoryArray = [DishCategoryItem mj_objectArrayWithKeyValuesArray:item.child];
        _range = NSMakeRange(indexPath.row + 1, _dishSubCategoryArray.count);
        [self.dishCategoryArray removeObjectsInRange:_range];
        [self.tableView reloadData];
        item.spreadStatus = NO;
        return;
    }
    //点击了未展开的有子分类的主分类
    if (item.child) {
        //获取对应子分类数据, 展开
        self.dishSubCategoryArray = [DishCategoryItem mj_objectArrayWithKeyValuesArray:item.child];
        
        _range = NSMakeRange(indexPath.row + 1, _dishSubCategoryArray.count);
        NSIndexSet *index = [[NSIndexSet alloc] initWithIndexesInRange:_range];
        [self.dishCategoryArray insertObjects:self.dishSubCategoryArray atIndexes:index];
        //刷新tableview
        [self.tableView reloadData];
        //此时是展开状态
        item.spreadStatus = YES;
    }
}

#pragma mark - UICollectionViewDataSource
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return 1;
//}
@end
