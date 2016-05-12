//
//  DishDetailView.m
//  E-Order
//
//  Created by 杨卢青 on 16/5/10.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "DishDetailView.h"
#import "DishBriefItem.h"
#import <UIImageView+WebCache.h>
#import "DishSpecialOrderItem.h"
#import "SpecialOrderCell.h"
#import "DishPeiTaoGroupItem.h"
#import "DishPeitaoCell.h"
#import "DishSubPeiTaoItem.h"
#import "DishPeitaoHeaderView.h"

@interface DishDetailView()<UICollectionViewDelegate, UICollectionViewDataSource, DishPeitaoCellDelegate>
//菜品图片
@property (weak, nonatomic) IBOutlet UIImageView *dishImageView;
//菜品价格
@property (weak, nonatomic) IBOutlet UILabel *dishPriceLabel;
//菜品名称
@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel;
//菜品介绍
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

//点菜数量
@property (weak, nonatomic) IBOutlet UILabel *orderCountLabel;
//盛放特殊要求button的View
@property (weak, nonatomic) IBOutlet UIView *specialOrderView;
@property (weak, nonatomic) IBOutlet UICollectionView *specialOrderCollectionView;
//配套 collection
@property (weak, nonatomic) IBOutlet UICollectionView *supportingCollectionView;
//特殊要求数据
@property (nonatomic, strong) NSArray *specialOrderArray;
//配套组数据
@property (nonatomic, strong) NSArray *peitaoGroupArray;
//配套数据,  配套直接用配套数据
@property (nonatomic, strong) NSMutableArray *peitaoArray;
@end

//Identifier
static NSString *const IDforspecialCell = @"IDforspecialCell";
static NSString *const IDforPeitaoCell = @"IDforPeitaoCell";
static NSString *const IDforpeitaoHeader = @"IDforpeitaoHeader";
@implementation DishDetailView

#pragma mark - 懒加载
- (NSArray *)pritaoGroupArray
{
    if (!_peitaoGroupArray) {
        _peitaoGroupArray = [NSArray array];
    }
    return _peitaoGroupArray;
}

/**
 *  重写set方法接受数据,并改变View的属性
 *
 *  @param item 菜品数据模型
 */
- (void)setItem:(DishBriefItem *)item
{
    _item = item;
    [self.dishImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DCBaseImage, item.image]]];
    self.dishPriceLabel.text = item.price;
    self.dishNameLabel.text = item.name;
    self.orderCountLabel.text = [NSString stringWithFormat:@"%ld", item.orderCount];
    self.contentTextView.text = item.content;
    
    [self setupspecialCollection];
    [self setupsupportingCollection];
}

- (void)setupspecialCollection
{
    self.specialOrderArray = _item.teshuyaoqiu;
    
    self.specialOrderCollectionView.delegate = self;
    self.specialOrderCollectionView.dataSource = self;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置layout
    NSInteger cols = 6;
    NSInteger rows = 2;
    CGFloat margin = 0;
    CGFloat cellW = (self.specialOrderCollectionView.width/ cols);
    CGFloat cellH = (self.specialOrderCollectionView.height/rows);
    layout.itemSize = CGSizeMake(cellW + 1, cellH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    //把layout给CollectionView
    [self.specialOrderCollectionView setCollectionViewLayout:layout];
    //注册
    [self.specialOrderCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SpecialOrderCell class]) bundle:nil] forCellWithReuseIdentifier:IDforspecialCell];
     self.specialOrderCollectionView.backgroundColor = UIColorFromHex(0xFFFEFB);
}

- (void)setupsupportingCollection
{
    self.peitaoGroupArray =  _item.peitao;
    self.supportingCollectionView.delegate = self;
    self.supportingCollectionView.dataSource = self;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置layout
    NSInteger cols = 3;
    NSInteger rows = 7;
    CGFloat margin = 2;
    CGFloat cellW = ((self.supportingCollectionView.width - (cols - 1) * margin) / cols);
    CGFloat cellH = ((self.supportingCollectionView.height - (rows - 1) * margin)/rows);
    layout.itemSize = CGSizeMake(cellW + 50, cellH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //把layout给CollectionView
    [self.supportingCollectionView setCollectionViewLayout:layout];
    //注册
    [self.supportingCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DishPeitaoCell class]) bundle:nil] forCellWithReuseIdentifier:IDforPeitaoCell];
    [self.supportingCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DishPeitaoHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:IDforpeitaoHeader];
    self.supportingCollectionView.backgroundColor = UIColorFromHex(0xFEF4E5);
}

#pragma mark - 点击取消
- (IBAction)cancleButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickCancelButtonWithItem:)]) {
        [self.delegate clickCancelButtonWithItem:self.item];
    }
}
- (IBAction)minusButtonClick:(id)sender {
    //修改模型
    if (0 == _item.orderCount) {
        return;
    }
    _item.orderCount--;
    _orderCountLabel.text = [NSString stringWithFormat:@"%ld", _item.orderCount];
}
- (IBAction)addButtonClick:(id)sender {
    //修改模型
    _item.orderCount++;
    _orderCountLabel.text = [NSString stringWithFormat:@"%ld", _item.orderCount];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_specialOrderCollectionView == collectionView) {
        return 1;
    }else{
        return self.pritaoGroupArray.count;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_specialOrderCollectionView == collectionView) {
       return self.specialOrderArray.count;
    }
    DishPeiTaoGroupItem *item = self.pritaoGroupArray[section];
    return item.arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_specialOrderCollectionView == collectionView) {
        DishSpecialOrderItem *item = self.specialOrderArray[indexPath.row];
        SpecialOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDforspecialCell forIndexPath:indexPath];
        cell.item = item;
        return cell;
    }
    
    DishPeiTaoGroupItem *groupItem = self.pritaoGroupArray[indexPath.section];
    DishSubPeiTaoItem *subItem = groupItem.arr[indexPath.row];
    [self.peitaoArray addObject:subItem];
    DishPeitaoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDforPeitaoCell forIndexPath:indexPath];
    cell.item = subItem;
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    if (_supportingCollectionView == collectionView) {
        CGSize size = {self.supportingCollectionView.width,self.supportingCollectionView.height/7};
        return size;

    }
    CGSize size = CGSizeZero;
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DishPeitaoHeaderView *headView;
    
    
    if([kind isEqual:UICollectionElementKindSectionHeader] && _supportingCollectionView == collectionView)
    {
        headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:IDforpeitaoHeader forIndexPath:indexPath];
        DishPeiTaoGroupItem *groupItem = self.pritaoGroupArray[indexPath.section];
        headView.headerLabel.text = groupItem.name;
    }
    
    return headView;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_specialOrderCollectionView == collectionView) {
        DishSpecialOrderItem *item = self.specialOrderArray[indexPath.row];
        item.selectedStatus = !item.isSelected;
        [self.specialOrderCollectionView reloadData];
    }
}

#pragma mark - DishPeitaoCellDelegate
- (void)addButtonFromPeitaoCellClick:(DishPeitaoCell *)cell
{
    [self refreshDataWithCell:cell];
}

- (void)minusButtonFromPeitaoCellClick:(DishPeitaoCell *)cell
{
    [self refreshDataWithCell:cell];
}

- (void)refreshDataWithCell:(DishPeitaoCell *)cell
{
    //配套组id
    DishSubPeiTaoItem *cellItem = cell.item;
    for (int i = 0; i < self.peitaoArray.count; i++) {
        DishSubPeiTaoItem *item = self.peitaoArray[i];
        if (item.garnish_id == cellItem.garnish_id && item.supporting_id == cellItem.supporting_id) {
            self.peitaoArray[i] = cellItem;
        }
    }
}

@end
