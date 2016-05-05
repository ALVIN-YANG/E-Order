//
//  DCLoginViewController.m
//  E-Order
//
//  Created by 杨卢青 on 16/5/4.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "DCLoginViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJExtension/MJExtension.h>

@interface DCLoginViewController()
//是否在请求状态
@property (nonatomic, assign)BOOL isRequesting;
//请求管理者
@property (nonatomic, strong) AFHTTPSessionManager *mgr;

@property (weak, nonatomic) IBOutlet UIButton *employeeButton;
@property (weak, nonatomic) IBOutlet UIButton *kitchenButton;
@end

@implementation DCLoginViewController

- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        _mgr = [AFHTTPSessionManager manager];
    }
    return _mgr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI
{
    self.navigationController.navigationBarHidden = YES;
    self.employeeButton.layer.cornerRadius = 3.0;
    self.kitchenButton.layer.cornerRadius = 3.0;
}

- (IBAction)loginButtonClick:(id)sender {
    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
    //拼接parameters
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"username"] = @"newboll";
    parameters[@"password"] = @"newboll1";
    NSString *askString = [NSString stringWithFormat:@"%@/Home/user/ajaxlogin", DCBaseUrl];
    [self.mgr GET:askString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dicc = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSInteger number = [[dicc objectForKey:@"msg"]integerValue];
        if (1 == number) {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //返回错误代码
        if (error.code == NSURLErrorCancelled) return;
        [SVProgressHUD showErrorWithStatus:@"网络繁忙,稍后尝试"];
    }];
    

}
- (IBAction)employeeButtonClick:(id)sender {
}
- (IBAction)kittenButtonClick:(id)sender {
}
@end
