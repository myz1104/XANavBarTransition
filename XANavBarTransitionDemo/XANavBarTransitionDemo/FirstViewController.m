//
//  FirstViewController.m
//  demo_导航栏平滑过渡
//
//  Created by XangAm on 2017/8/1.
//  Copyright © 2017年 Lan. All rights reserved.
//

#import "FirstViewController.h"
#import "XANavBarTransition.h"
#import "SecondViewController.h"
@interface FirstViewController ()<XANavBarTransitionDelegate>
@property (nonatomic, strong) UIViewController *desViewController;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    
}

- (void)setup{
    self.desViewController = [[UIViewController alloc]init];
    self.desViewController.view.backgroundColor = [UIColor redColor];
    self.title = @"1";
    self.extendedLayoutIncludesOpaqueBars = YES;
}

#pragma mark - <XANavBarTransitionDelegate>
- (UIViewController *)xa_slideToNextViewController:(UINavigationController *)nc
                                    transitionType:(TransitionType)transitionType{
    
    return self.desViewController;
}




@end
