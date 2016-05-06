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

@property (nonatomic, weak)SelectTabelController *selTableVC;
@end

@implementation DCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selTableVC = [[UIStoryboard storyboardWithName:NSStringFromClass([SelectTabelController class]) bundle:nil] instantiateInitialViewController];
    self.selTableVC.delegate = self;
    //此句非常重要
    [self addChildViewController:_selTableVC];
    
    [self.containView addSubview:_selTableVC.view];
    _selTableVC.view.frame = self.containView.bounds;
}

#pragma mark - SelectTabelControllerDelegate
- (void)jumpToOrderViewController
{
#warning 想移除子控制器的
    [self.selTableVC.view removeFromSuperview];
    self.selTableVC = nil;
    
    OrderViewController *orderVC = [[UIStoryboard storyboardWithName:NSStringFromClass([OrderViewController class]) bundle:nil] instantiateInitialViewController];
    //此句非常重要
    [self addChildViewController:orderVC];
    
    [self.containView addSubview:orderVC.view];
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

- (IBAction)selectTableButtonClick:(id)sender {
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
