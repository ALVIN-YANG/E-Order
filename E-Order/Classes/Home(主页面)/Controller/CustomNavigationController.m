//
//  CustomNavigationController.m
//  E-Order
//
//  Created by 杨卢青 on 16/5/5.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

#pragma mark - load
+ (void)load{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] init];
    
    [navigationBar setBackgroundColor:[UIColor orangeColor]];
    [navigationBar setTintColor:[UIColor orangeColor]];
//    [self setBackItem];
   
}

- (void)setBackItem
{
    
    

}

#pragma mark - push
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //要判断是不是根控制器,  viewController
    viewController.navigationItem.leftBarButtonItem.title = @"";
    viewController.navigationController.navigationBarHidden = NO;
    
    //设置返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateHighlighted];
    [btn setTitle:@"" forState:UIControlStateNormal];
    [btn sizeToFit];
    //设置内边距
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIView *view = [[UIView alloc]initWithFrame:btn.bounds];
    [view addSubview:btn];
    viewController.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:view];
    
    //设置右边按钮
    
    //调用父类的push
    [super pushViewController:viewController animated:animated];
}


- (void)back{
    [self popViewControllerAnimated:YES];
}
@end
