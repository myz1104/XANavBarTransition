//
//  XABaseTransition.m
//  XANavBarTransitionDemo
//
//  Created by xangam on 2018/5/21.
//  Copyright © 2018年 Lan. All rights reserved.
//

#import "XABaseTransition.h"
#import "UINavigationController+XANavBarTransition.h"
#import "XABaseTransition.h"
@interface XABaseTransition()
@property (nonatomic, weak)   UIView *transitionView;

@end

@implementation XABaseTransition

- (instancetype)initWithNavigationController:(UINavigationController *)nc{
    if(self = [super init]){
        [self setup:nc];
    }
    return self;
}

#pragma mark - Setup
- (void)setup:(UINavigationController *)nc{
    self.nc = nc;
    self.transitionView = nc.view;
    [self setupGestureRecognize:nc.view];
}

- (void)setupGestureRecognize:(UIView *)transitionView{
    self.interactivePan.enabled  = YES;
    self.interactivePan.delegate = self;
    self.transitionEnable = self.interactivePan.enabled;
    [transitionView addGestureRecognizer:self.interactivePan];
}

#pragma mark - Action
- (void)interactiveTransitioningEvent:(UIPanGestureRecognizer *)pan{
    static NSTimeInterval beginTouchTime,endTouchTime;//beginTouchTime和endTouchTime这两个数据量主要是用于参考是否为轻扫
    CGPoint translationPoint = [pan translationInView:self.transitionView];
    CGFloat progress = [self calcTransitioningProgress:translationPoint];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        beginTouchTime = [[NSDate date]timeIntervalSince1970];
        UIViewController *nextViewController =   [self.nc.xa_transitionDelegate xa_slideToNextViewController:self.nc transitionType:self.transitionType];
        [self.nc pushViewController:nextViewController animated:YES];
        [self.interactive updateInteractiveTransition:0];
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        
        [self.interactive updateInteractiveTransition:progress];
        
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        
        endTouchTime = [[NSDate date]timeIntervalSince1970];
        CGFloat dValueTime = endTouchTime - beginTouchTime;
        if (progress > 0.3 || dValueTime <= 0.15f) {//dValueTime <= 0.15f 该条件用于判断是否为轻扫
            [self.interactive finishInteractiveTransition];
        } else {
            [self.interactive cancelInteractiveTransition];
        }
        self.interactive = nil;
    }
}

#pragma mark - Deal

- (CGFloat)calcTransitioningProgress:(CGPoint)translationPoint{
    return 0;
}



#pragma mark - Getter/Setter
- (void)setTransitionEnable:(BOOL)transitionEnable{
    _transitionEnable = transitionEnable;
    self.interactivePan.enabled = transitionEnable;
    
    //如果关闭了全屏滑动,就开启系统的边缘滑动并接管代理
    //    BOOL interactivePopEnabled  =  !self.fullscreenPanGestureRecognizer.enabled;
    //需求,不开启侧滑
//    BOOL interactivePopEnabled = NO;
//    self.interactivePopGestureRecognizer.enabled  = interactivePopEnabled;
//    self.interactivePopGestureRecognizer.delegate = interactivePopEnabled ? self : self.interactivePopGestureRecognizerDelegate;
}

- (UIPercentDrivenInteractiveTransition *)interactive{
    if(_interactive == nil){
        _interactive = ({
            UIPercentDrivenInteractiveTransition *interactive = [[UIPercentDrivenInteractiveTransition alloc] init];
            interactive.completionCurve = UIViewAnimationCurveEaseOut;
            interactive.completionSpeed = 0.99;
            interactive;
        });
    }
    return _interactive;
}

- (UIPanGestureRecognizer *)interactivePan{
    if(_interactivePan == nil){
        _interactivePan = ({
            UIPanGestureRecognizer *interactiveGR  = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(interactiveTransitioningEvent:)];
            interactiveGR;
        });
    }
    return _interactivePan;
}

@end