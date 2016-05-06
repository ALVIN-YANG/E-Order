//
//  ConfirmAlertView.h
//  E-Order
//
//  Created by 杨卢青 on 16/5/6.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TableOpenRequestItem;

@protocol ConfirmAlertViewDelegate <NSObject>

//点击取消
- (void)didCancleButtonClick;
//点击确定
- (void)didConfirmButtonClickWithItem:(TableOpenRequestItem *)item;

//当用户开始编辑时, 弹窗上移
- (void)userBeginEdit;
//当用户结束编辑时, 弹窗复位
- (void)userEndEdit;
@end

@interface ConfirmAlertView : UIView
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//开桌数据模型, 将来用作默认
@property (nonatomic, strong) TableOpenRequestItem *item;
//代理
@property (nonatomic, weak)id<ConfirmAlertViewDelegate> delegate;

//结束所有编辑状态
- (void)endAllTextFieldEdit;
@end
