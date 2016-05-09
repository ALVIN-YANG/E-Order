//
//  DCMainViewController.m
//  E-Order
//
//  Created by 杨卢青 on 16/5/5.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "DCMainViewController.h"
#import "SelectTabelController.h"
#import "OrderViewController.h"

@interface DCMainViewController ()<SelectTabelControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *containView;

@end

@implementation DCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //首先进入选桌界面
    [self jumpToSelectTableController];
    
}

#pragma mark - Helpers
/**
 *  进入选桌界面
 */
- (void)jumpToSelectTableController
{
    //移除ContainView的所有子视图
    for(UIView *view in [self.containView subviews])
    {
        [view removeFromSuperview];
    }
    
    SelectTabelController *selTableVC = [[UIStoryboard storyboardWithName:NSStringFromClass([SelectTabelController class]) bundle:nil] instantiateInitialViewController];
    selTableVC.delegate = self;
    //此句非常重要
    [self addChildViewController:selTableVC];
    
    [self.containView addSubview:selTableVC.view];
    selTableVC.view.frame = self.containView.bounds;
}

#pragma mark - SelectTabelControllerDelegate
/**
 *  进入点菜界面
 */
- (void)jumpToOrderViewControllerWithTableName:(NSString *)tableName
{
    //移除ContainView的所有子视图
    for(UIView *view in [self.containView subviews])
    {
        [view removeFromSuperview];
    }
    
    //创建点菜控制器, 把view加入容器视图
    OrderViewController *orderVC = [[UIStoryboard storyboardWithName:NSStringFromClass([OrderViewController class]) bundle:nil] instantiateInitialViewController];
    
    //此句非常重要
    [self addChildViewController:orderVC];
    
    [self.containView addSubview:orderVC.view];
    orderVC.tableName.text = tableName;
    orderVC.view.frame = self.containView.bounds;
}



- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)firstButtonClick:(id)sender {
}

- (IBAction)secondButtonClick:(id)sender {
}

- (IBAction)thirdButtonClick:(id)sender {
}

- (IBAction)fourthButtonClick:(id)sender {
}

//点击桌位选择
- (IBAction)selectTableButtonClick:(id)sender {
    [self jumpToSelectTableController];
}

- (IBAction)flowButtonClick:(id)sender {
}

- (IBAction)introductionButtonClick:(id)sender {
}

- (IBAction)commentButtonClick:(id)sender {
}

- (IBAction)callButtonClick:(id)sender {
}

@end
