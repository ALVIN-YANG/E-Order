//
//  DCMainViewController.m
//  E-Order
//
//  Created by 杨卢青 on 16/5/5.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "DCMainViewController.h"
#import "SelectTabelController.h"

@interface DCMainViewController ()
@property (weak, nonatomic) IBOutlet UIView *containView;

@end

@implementation DCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SelectTabelController *selTableVC = [[UIStoryboard storyboardWithName:NSStringFromClass([SelectTabelController class]) bundle:nil] instantiateInitialViewController];
    
    //此句非常重要
    [self addChildViewController:selTableVC];
    
    [self.containView addSubview:selTableVC.view];
    selTableVC.view.frame = self.containView.bounds;
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
