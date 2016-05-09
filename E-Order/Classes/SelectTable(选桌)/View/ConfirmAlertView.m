//
//  ConfirmAlertView.m
//  E-Order
//
//  Created by 杨卢青 on 16/5/6.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "ConfirmAlertView.h"
#import "TableOpenRequestItem.h"

@interface ConfirmAlertView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UITextField *waiterTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end
@implementation ConfirmAlertView

- (void)awakeFromNib
{
    //设置代理
    self.countTextField.delegate = self;
    self.waiterTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

/**
 *  懒加载属性,保持唯一
 */
- (TableOpenRequestItem *)item
{
    if (!_item) {
        _item = [[TableOpenRequestItem alloc] init];
    }
    return _item;
}
/**
 *  点击确认按钮
 */
- (IBAction)confirmButtonClick:(id)sender {
    self.item.count = self.countTextField.text;
    self.item.waiter = self.waiterTextField.text;
    self.item.password = self.passwordTextField.text;
    self.item.tableName = self.titleLabel.text;
    
    NSLog(@"\ntitleLabel:\n%@", _titleLabel.text);
    NSLog(@"\ntitleLabel:\n%@", _item.tableName);
    if ([self.delegate respondsToSelector:@selector(didConfirmButtonClickWithItem:)]) {
        [self.delegate didConfirmButtonClickWithItem:self.item];
    }
}

/**
 *  点击取消按钮
 */
- (IBAction)cancleButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didCancleButtonClick)]) {
        [self.delegate didCancleButtonClick];
    }
}

/**
 *  取消所有编辑状态
 */
- (void)endAllTextFieldEdit
{
    [self.countTextField endEditing:YES];
    [self.waiterTextField endEditing:YES];
    [self.passwordTextField endEditing:YES];
}

#pragma mark - UITextFieldDelegate
//进入编辑状态时
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(userBeginEdit)]) {
        [self.delegate userBeginEdit];
    }
}

//退出编辑状态时
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(userEndEdit)]) {
        [self.delegate userEndEdit];
    }
}

//点击Return按键时退出
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //重置键盘, 会进入退出编辑状态
    [textField resignFirstResponder];
    return YES;
}
@end
