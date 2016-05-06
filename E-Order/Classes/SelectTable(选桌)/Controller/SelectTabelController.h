//
//  SelectTabelController.h
//  E-Order
//
//  Created by 杨卢青 on 16/5/5.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectTabelControllerDelegate <NSObject>

- (void)jumpToOrderViewController;

@end
@interface SelectTabelController : UIViewController

@property (nonatomic, weak)id<SelectTabelControllerDelegate> delegate;
@end
