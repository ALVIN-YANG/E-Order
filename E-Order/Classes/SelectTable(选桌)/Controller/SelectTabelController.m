//
//  SelectTabelController.m
//  E-Order
//
//  Created by 杨卢青 on 16/5/5.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "SelectTabelController.h"

//cell
#import "SelectTebleCell.h"
#import "SelectCollectionCell.h"

//楼层数据模型
#import "TableCategoryItem.h"
//楼层对应桌子数据模型
#import "TableStatusItem.h"
//发送桌位信息模型
#import "TableOpenRequestItem.h"

//提示开桌View
#import "ConfirmAlertView.h"

//导入选菜界面
#import "OrderViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>



@interface SelectTabelController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, ConfirmAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//楼层数据
@property (nonatomic, strong) NSArray *tableCategoryArray;
//楼层对应桌子数据
@property (nonatomic, strong) NSArray *tableStatusArray;
//请求管理
@property (nonatomic, strong) AFHTTPSessionManager *mgr;

//确认View
@property (nonatomic, strong) ConfirmAlertView *confirmView;
//蒙版view
@property (nonatomic, strong) UIView *grayView;
//记录tableName
@property (nonatomic, copy) NSString *tableName;
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
    
    //请求楼号数据
    [self requestTableCategoryData];
    //几楼
    [self setupTableView];
    //桌位
    [self setupCollectionView];
}

#pragma mark - Helpers
//请求楼号数据
- (void)requestTableCategoryData
{

    NSString *followURL = @"/Home/user/tablecategory";
    NSString *askingURL = [NSString stringWithFormat:@"%@%@", DCBaseUrl, followURL];
    [self.mgr POST:askingURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

//结束确认弹窗的编辑状态
- (void)endConfirmViewEditing
{
    [self.confirmView endAllTextFieldEdit];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableView.height/12;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //请求对应collection数据
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TableStatusItem *item = self.tableStatusArray[indexPath.row];
    
#warning 桌位有限, 测试用, 上线时解除注释
    //如果桌位已满则点击无效
    if (1 == item.status.integerValue) {
//        return;
    }
    
    //添加蒙版,再添加View
    self.grayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _grayView.backgroundColor = [UIColor blackColor];
    _grayView.alpha = 0.7;
    //添加点击手势, 点击蒙版, 退出编辑状态
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endConfirmViewEditing)];
    [_grayView addGestureRecognizer:tapGes];
    
    //为了遮挡住最上层View
    [self.view.superview.superview addSubview:self.grayView];
    
    self.confirmView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ConfirmAlertView class]) owner:self options:nil] lastObject];
    _confirmView.center = _grayView.center;
    _confirmView.size = CGSizeMake(ScreenW/3, ScreenH/3);
    _confirmView.titleLabel.text = [NSString stringWithFormat:@"将要打开桌位:%@", item.number];
    //记录桌名, 传递
    self.tableName = item.number;
    //传入ID
    _confirmView.item.tableid = item.table_id;
    _confirmView.delegate = self;
    [self.view.superview.superview addSubview:self.confirmView];
}

#pragma mark - ConfirmAlertViewDelegate
/**
 *  点击取消
 */
- (void)didCancleButtonClick
{
    [self.grayView removeFromSuperview];
    [self.confirmView removeFromSuperview];
    self.grayView = nil;
    self.confirmView = nil;
}
/**
 *  点击确认, 给数据库当前桌位信息, 并跳转到点菜界面
 *
 *  @param item 桌位信息数据模型
 */
- (void)didConfirmButtonClickWithItem:(TableOpenRequestItem *)item
{
    [self didCancleButtonClick];
    NSLog(@"\n 人数 : %@ \n 服务员 : %@ \n 密码 : %@ \n 桌名: %@", item.count, item.waiter, item.password, item.tableName);
    //发送请求
    NSString *followURL = @"/Home/user/tablestatus";
    NSString *askingURL = [NSString stringWithFormat:@"%@%@", DCBaseUrl, followURL];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"tableid"] = item.tableid;
    parameters[@"warter"]  = item.waiter;
    parameters[@"count"]   = item.count;
    parameters[@"password"]= item.password;
    [_mgr POST:askingURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        TableOpenRequestItem *item = [TableOpenRequestItem mj_objectWithKeyValues:responseObject];
        if (1 == item.msg.integerValue) {
            //提交成功进入选菜界面
            if ([self.delegate respondsToSelector:@selector(jumpToOrderViewControllerWithTableName:)]) {
                [self.delegate jumpToOrderViewControllerWithTableName:self.tableName];
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\nerror:\n%@", error);
        [SVProgressHUD showErrorWithStatus:@"请求桌子信息失败\n请稍后尝试"];
    }];
}
/**
 *  用户开始编辑桌位信息时, 弹窗上移
 */
- (void)userBeginEdit
{
    [UIView animateWithDuration:0.4 animations:^{
        self.confirmView.y -= 142;
    }];
}
/**
 *  用户退出编辑时, 弹窗复位
 */
- (void)userEndEdit
{
    [UIView animateWithDuration:0.4 animations:^{
        self.confirmView.y += 142;
    }];
}
@end
