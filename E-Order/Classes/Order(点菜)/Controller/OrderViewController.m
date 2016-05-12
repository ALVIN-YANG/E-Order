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
#import "DishBriefItem.h"
//配套组
#import "DishPeiTaoGroupItem.h"
//配套
#import "DishSubPeiTaoItem.h"
//特殊要求
#import "DishSpecialOrderItem.h"
//cell
#import "DishCategoryCell.h"
#import "DishBriefCell.h"
#import "DishSubCategoryCell.h"
//抛物线动画工具
#import "ThrowLineTool.h"
//菜品详情View
#import "DishDetailView.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>

@interface OrderViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, DishBriefCellDelegate, ThrowLineToolDelegate, DishDetailViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;

//请求管理
@property (nonatomic, strong) AFHTTPSessionManager *mgr;

//菜品分类模型数组
@property (nonatomic, strong) NSMutableArray *dishCategoryArray;
//当前主分类菜品的子分类, 要插入到主分类里面, 记录主分类的index
@property (nonatomic, strong) NSMutableArray *dishSubCategoryArray;
//工具range
@property (nonatomic, assign) NSRange range;
//上次点击的index
@property (nonatomic, assign) NSInteger lastClickIndex;

/**
 *  详细菜品模型数据  存放DishBriefItem
 */
@property (nonatomic, strong) NSMutableArray *dishDetailArray;
/**
 *   所有的 详细菜品数据
 */
@property (nonatomic, strong) NSMutableArray *allData;

//抛物球
@property (nonatomic, strong) UIImageView *redView;

/**
 *  确认View
 */
@property (nonatomic, strong) DishDetailView *detailView;
/**
 *  蒙版view
 */
@property (nonatomic, strong) UIView *grayView;

/**
 *  菜单
 */
@property (nonatomic, strong) NSMutableArray *dishChartArray;
@end

//主分类和子分类查询的URL不同
static NSString * const mainfollowURL = @"/Home/user/alldish";
static NSString * const subfollowURL  = @"/Home/user/categorydish";
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

- (NSMutableArray *)dishDetailArray {
    if (!_dishDetailArray) {
        _dishDetailArray = [NSMutableArray array];
    }
    return _dishDetailArray;
}

- (NSMutableArray *)dishChartArray {
    if (!_dishChartArray) {
        _dishChartArray = [NSMutableArray array];
    }
    return _dishChartArray;
}

- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        _mgr = [AFHTTPSessionManager manager];
    }
    return _mgr;
}

- (UIImageView *)redView {
    if (!_redView) {
        _redView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//        _redView.image = [UIImage imageNamed:@"adddetail"];
        _redView.backgroundColor = [UIColor redColor];
        _redView.layer.cornerRadius = 10;
    }
    return _redView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化属性
    [self initAttribute];
    //请求菜品分类
    [self requestDishCatagoryData];
    
    //设置菜品分类Table
    [self setupTableView];
    
    //设置分类对应菜品
    [self setupCollectionView];
    
    //抛物球代理
    [ThrowLineTool sharedTool].delegate = self;
}

- (void)initAttribute
{
    self.lastClickIndex = MAXFLOAT;
    _totalCountLabel.layer.cornerRadius = _totalCountLabel.height * 0.5;
    _totalCountLabel.clipsToBounds = YES;
    _totalCountLabel.hidden = YES;
}

#pragma mark - Helpers
- (void)requestDishCatagoryData
{
    NSString *followURL = @"/Home/user/dishcategory";
    NSString *askingURL = [NSString stringWithFormat:@"%@%@", DCBaseUrl, followURL];
    [self.mgr POST:askingURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        //得到菜品分类数据
        self.dishCategoryArray = [DishCategoryItem mj_objectArrayWithKeyValuesArray:responseObject];
        
        //刷新tableView
        [self.tableView reloadData];
        
        //请求根据第一个菜品分类模型的id 请求该分类对应的菜品数据
//        DishCategoryItem *firstItem = self.dishCategoryArray[0];
        
        [self requestDishBriefData:nil withfollowURL:mainfollowURL];
        
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
- (void)requestDishBriefData:(NSString *)categoryName withfollowURL:(NSString *)followURL
{
    //通过分类名称筛选 详细菜品
    if (categoryName) {
        DishBriefItem *briefItem;
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (int i = 0; i < _allData.count; i++) {
            briefItem = _allData[i];
            if ([briefItem.catename isEqualToString:categoryName]) {
                [mutableArray addObject:briefItem];
            }
        }
        _dishDetailArray = mutableArray;
        
        [self.collectionView reloadData];
        return;
    }
    
    NSString *askingURL = [NSString stringWithFormat:@"%@%@", DCBaseUrl, followURL];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [self.mgr POST:askingURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //得到菜品分类数据
        //全部解析!!
        _allData = [DishBriefItem mj_objectArrayWithKeyValuesArray:responseObject];
        NSMutableArray *briefArray = [NSMutableArray array];
        for (int i = 0; i < _allData.count; i++) {
           DishBriefItem *briefitem = _allData[i];
            briefitem.peitao = [DishPeiTaoGroupItem mj_objectArrayWithKeyValuesArray:briefitem.peitao];
            
            briefitem.teshuyaoqiu = [DishSpecialOrderItem mj_objectArrayWithKeyValuesArray:briefitem.teshuyaoqiu];
            NSMutableArray *peitao = [NSMutableArray array];
            //配套多一层
            for (int j = 0; j < briefitem.peitao.count; j++) {
                DishPeiTaoGroupItem *groupItem = briefitem.peitao[j];
                groupItem.arr = [DishSubPeiTaoItem mj_objectArrayWithKeyValuesArray:groupItem.arr];
                NSMutableArray *arr = [NSMutableArray array];
                for (int k = 0; k < groupItem.arr.count; k++) {
                    [arr addObject:groupItem.arr[k]];
                }
                groupItem.arr = arr;
                [peitao addObject:groupItem];
            }
            briefitem.peitao = peitao;
            
            [briefArray addObject: briefitem];
        }
        _allData = briefArray;
        _dishDetailArray = _allData;
         [_dishDetailArray writeToFile:@"/Users/YLQ/Desktop/Eplist/详情点菜.plist" atomically:YES];
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
}

/**
 *  设置分类对应菜品collectionView
 */
- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置layout
    NSInteger cols = 3;
    NSInteger rows = 3;
    CGFloat margin = 2.0;
    CGFloat cellW = ((self.collectionView.width - (cols - 1) * margin)/ cols);
    CGFloat cellH = ((self.collectionView.height - (rows - 1) * margin)/ rows);
    layout.itemSize = CGSizeMake(cellW, cellH - 16);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    //把layout给CollectionView
    [self.collectionView setCollectionViewLayout:layout];
    //注册
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DishBriefCell class]) bundle:nil] forCellWithReuseIdentifier:CellIDforDetail];
    
    self.collectionView.backgroundColor = Color(248, 236, 191);
    //代理数据源
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}

#pragma mark - 本类点击事件
/**
 * 已点菜单点击
 */
- (IBAction)alreadyDishButtonClick:(id)sender {
    
     [_dishChartArray writeToFile:@"/Users/YLQ/Desktop/Eplist/chart菜单.plist" atomically:YES];
    DishBriefItem *brief = _dishChartArray[0];
    DishPeiTaoGroupItem *group = brief.peitao[0];
    DishSubPeiTaoItem *sub = group.arr[0];
    NSLog(@"%@", sub.name);
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
    
    //点击了子分类, tableview没有状态改变
    if (0 != item.parent_id.integerValue) {
        //请求对应collection数据
        [self requestDishBriefData:item.name withfollowURL:subfollowURL];
        NSLog(@"\ntem.name\n%@", item.name);
        return;
    }
    //请求对应collection数据
    [self requestDishBriefData:item.name withfollowURL:mainfollowURL];
    NSLog(@"\ntem.name\n%@", item.name);
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dishDetailArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DishBriefItem *item = _dishDetailArray[indexPath.row];
    DishBriefCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIDforDetail forIndexPath:indexPath];
    cell.delegate = self;
    cell.item = item;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    DishBriefItem *item = _dishDetailArray[indexPath.row];
    
    self.detailView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DishDetailView class]) owner:self options:nil] firstObject];
    self.detailView.item = item;
    self.detailView.delegate = self;
    //添加蒙版,再添加View
    self.grayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _grayView.backgroundColor = [UIColor blackColor];
    _grayView.alpha = 0.7;
    
    //为了遮挡住最上层View
    [self.view.superview.superview.superview addSubview:_grayView];
   
    self.detailView.frame = CGRectMake(self.collectionView.x - self.tableView.width/3 * 1, self.collectionView.y + 20, ScreenW/4 * 3, ScreenH/15 * 14);
    
    [self.view.superview.superview.superview addSubview:_detailView];
    
}

#pragma mark - DishBriefCellDelegate
- (void)clickDishAddButton:(DishBriefCell *)cell
{
    DishBriefItem *item;
    BOOL flag = NO;
    for (int i = 0; i < _dishChartArray.count; i++) {
        item = _dishChartArray[i];
        if ([item.dish_id isEqualToString: cell.item.dish_id]) {
            //chart里已经存在
            _dishChartArray[i] = cell.item;
            flag = YES;
            break;
        }
    }
    //已点菜单里面没有此条
    if (!flag) {
        [_dishChartArray addObject:cell.item];
    }
    
    //更新所有数据
    for (int i = 0; i < _allData.count; i++) {
        item = _allData[i];
        if ([item.dish_id isEqualToString:cell.item.dish_id]) {
            _allData[i] = cell.item;
        }
    }
    
    [self RefreshTotalCounntLabel];
    
    
    //通过坐标转换得到抛物线的起点和终点
    CGRect parentRectA = [cell convertRect:cell.addButton.frame toView:self.view];
    [self.view addSubview:self.redView];
    [[ThrowLineTool sharedTool] throwObject:self.redView from:parentRectA.origin to:_totalCountLabel.frame.origin];
    
}

- (void)clickDishMinusButton:(DishBriefCell *)cell
{
    DishBriefItem *item;
    for (int i = 0; i < _dishChartArray.count; i++) {
        item = _dishChartArray[i];
        if ([item.dish_id isEqualToString: cell.item.dish_id]) {
            if (1 == cell.item.orderCount) {
                [_dishChartArray removeObjectAtIndex:i];
                
            }
            break;
        }
    }
    
    //更新所有数据
    for (int i = 0; i < _allData.count; i++) {
        item = _allData[i];
        if ([item.dish_id isEqualToString:cell.item.dish_id]) {
            _allData[i] = cell.item;
        }
    }
    
    [self RefreshTotalCounntLabel];
}

#pragma mark - ThrowLineToolDelegate
- (void)animationDidFinish
{
    [self.redView removeFromSuperview];
    [UIView animateWithDuration:0.1 animations:^{
        _totalCountLabel.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            _totalCountLabel.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];
        
    }];
}

#pragma mark - DishDetailViewDelegate
- (void)clickCancelButtonWithItem:(DishBriefItem *)item
{
    [self.grayView removeFromSuperview];
    [self.detailView removeFromSuperview];
    self.grayView = nil;
    self.detailView = nil;
    
    DishBriefItem *BriefItem;
    BOOL flag = NO;
    NSInteger num = 0;
    for (int i = 0; i < _dishChartArray.count; i++) {
        BriefItem = _dishChartArray[i];
        if ([BriefItem.dish_id isEqualToString: item.dish_id]) {
            //chart里已经存在
            num = item.orderCount - BriefItem.orderCount;
            _dishChartArray[i] = item;
            _allData[i] = item;
            [self.collectionView reloadData];
            flag = YES;
            break;
        }
    }
    
    //已点菜单里面没有此条
    if (!flag && item.orderCount != 0) {
        [self.dishChartArray addObject:item];
        
        for (int i = 0; i < _allData.count; i++) {
            BriefItem = _allData[i];
            if ([BriefItem.dish_id isEqualToString: item.dish_id]) {
                _allData[i] = item;
                [self.collectionView reloadData];
            }
        }
        num = item.orderCount;
    }else if (!flag && item.orderCount == 0) {
        return;
    }
    
    [self RefreshTotalCounntLabel];
}

- (void)RefreshTotalCounntLabel
{
    NSInteger sum = 0;
    for (DishBriefItem *item in _allData) {
        sum += item.orderCount;
    }
    
    if (0 == sum) {
        _totalCountLabel.hidden = YES;
    }else {
        _totalCountLabel.hidden = NO;
        _totalCountLabel.text = [NSString stringWithFormat:@"%ld", sum];
    }
}
@end
