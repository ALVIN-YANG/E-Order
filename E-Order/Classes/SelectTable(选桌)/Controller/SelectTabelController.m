//
//  SelectTabelController.m
//  E-Order
//
//  Created by 杨卢青 on 16/5/5.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "SelectTabelController.h"
#import "SelectTebleCell.h"
#import "SelectCollectionCell.h"
//楼层数据模型
#import "TableCategoryItem.h"
//楼层对应桌子数据模型
#import "TableStatusItem.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>



@interface SelectTabelController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//楼层数据
@property (nonatomic, strong) NSArray *tableCategoryArray;
//楼层对应桌子数据
@property (nonatomic, strong) NSArray *tableStatusArray;
//请求管理
@property (nonatomic, strong) AFHTTPSessionManager *mgr;
@end



//Identifier
static NSString * const CellIDforTable = @"tableCell";
static NSString * const CellIDforCollection = @"CollectionCell";

@implementation SelectTabelController
#pragma mark - 初始化懒加载
- (NSArray *)tableCategoryArray
{
    if (!_tableCategoryArray) {
        _tableCategoryArray = [NSArray array];
    }
    return _tableCategoryArray;
}

- (NSArray *)tableStatusArray
{
    if (!_tableStatusArray) {
        _tableStatusArray = [NSArray array];
    }
    return _tableStatusArray;
}

- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        _mgr = [AFHTTPSessionManager manager];
    }
    return _mgr;
}

#pragma mark - 控制器周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //请求楼号和楼号对应桌位状态数据
    [self requestTableCategoryData];
    //几楼
    [self setupTableView];
    //桌位
    [self setupCollectionView];
}

#pragma mark - Helpers
//请求楼号和楼号对应桌位状态数据
- (void)requestTableCategoryData
{

    NSString *followURL = @"/Home/user/tablecategory";
    NSString *askingURL = [NSString stringWithFormat:@"%@%@", DCBaseUrl, followURL];
    [self.mgr POST:askingURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"\n楼层分类数据:\n%@", responseObject);
        
        //得到楼层数据
        self.tableCategoryArray = [TableCategoryItem mj_objectArrayWithKeyValuesArray:responseObject];
        //刷新tableView
        [self.tableView reloadData];
        
        //请求根据第一个楼层模型的id 请求该楼层对应的桌位数据
        TableCategoryItem *firstItem = self.tableCategoryArray[0];
        [self requestTableStatusData:firstItem.table_category_id];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\nerror:\n%@", error);
        [SVProgressHUD showErrorWithStatus:@"获取桌位信息失败\n请稍后尝试"];
    }];
    
}

//请求根据第一个楼层模型的id 请求该楼层对应的桌位数据, 刷新CollectionView
- (void)requestTableStatusData:(NSString *)catagoryID
{
    NSString *sfollowURL = @"/Home/user/gettable";
    NSString *saskingURL = [NSString stringWithFormat:@"%@%@", DCBaseUrl, sfollowURL];
    //传入楼层id 返回该楼层所有桌子数据
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"tableid"] = catagoryID;
    
    [self.mgr POST:saskingURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"\n楼号对应桌位数据\n\n%@", responseObject);
         [responseObject writeToFile:@"/Users/YLQ/Desktop/Eplist/桌子状态.plist" atomically:YES];
        //得到桌子数据
        self.tableStatusArray = [TableStatusItem mj_objectArrayWithKeyValuesArray:responseObject];
        //刷新collectionView
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\nerror:\n%@", error);
        [SVProgressHUD showErrorWithStatus:@"获取楼号信息失败\n请稍后尝试"];
    }];
}

- (void)setupTableView
{
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectTebleCell" bundle:nil] forCellReuseIdentifier:CellIDforTable];
    
    [self.view addSubview:self.tableView];
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置layout
    NSInteger cols = 5;
    NSInteger rows = 7;
    CGFloat margin = 1.0;
    CGFloat cellW = ((self.collectionView.width - (cols - 1) * margin)/ cols);
    CGFloat cellH = ((self.collectionView.frame.size.height - (rows - 1) * margin)/rows);
    layout.itemSize = CGSizeMake(cellW, cellH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    //把layout给CollectionView
    [self.collectionView setCollectionViewLayout:layout];
    //注册
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SelectCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:CellIDforCollection];
    
    self.collectionView.backgroundColor = Color(248, 236, 191);
    [self.view addSubview:self.collectionView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableCategoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    SelectTebleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIDforTable];
    TableCategoryItem *item = self.tableCategoryArray[indexPath.row];
    cell.floorNumLabel.text = item.name;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableCategoryItem *item = self.tableCategoryArray[indexPath.row];
    [self requestTableStatusData:item.table_category_id];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.tableStatusArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SelectCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIDforCollection forIndexPath:indexPath];
    TableStatusItem *item = self.tableStatusArray[indexPath.row];
    cell.tableNumberLabel.text = item.number;
    if (0 == item.status.integerValue) {
        cell.backView.backgroundColor = Color(228, 222, 214);
        cell.statusLabel.text = @"开桌";
        cell.statusLabel.tintColor = Color(122, 117, 111);
        cell.tableNumberLabel.tintColor = Color(216, 104, 0);
        
    }else{
        cell.backView.backgroundColor = Color(236, 119, 36);
        cell.statusLabel.text = @"就餐中";
        cell.statusLabel.tintColor = Color(244, 186, 87);
        cell.tableNumberLabel.tintColor = Color(244, 186, 87);
    }
    return cell;
}
@end
