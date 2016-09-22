//
//  RefreshView.m
//  RefreshControl
//
//  Created by yxhe on 16/9/19.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

#import "RefreshView.h"

@interface HeaderView ()
{
    RefreshState _refreshState;
    RefreshState _preState;
}

@property (nonatomic, strong) UIImageView *arrowImageView;                      // 图片
@property (nonatomic, strong) UILabel *stateTextLabel;                     // 文字
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;  // 状态指示器

@end

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 图片(后续加入根据下拉的幅度播放帧动画)
        self.backgroundColor = [UIColor orangeColor];
        self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow1.png"]];
        self.arrowImageView.frame = CGRectMake(frame.size.width / 2 - 15, 0, 30, 30);
        [self addSubview:_arrowImageView];
        
        // 文字
        self.stateTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, 30)];
        self.stateTextLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_stateTextLabel];
        
        // 状态
        _preState = SNormal;
        self.refreshState = SNormal;
        
        // 指示器(与图片位置重合，互相切换隐藏，系统自带的，也可以自己定制)
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.frame = CGRectMake(frame.size.width / 2 - 15, 0, 30, 30);
        [self addSubview:_activityIndicator];
        
    }
    return self;
}

- (RefreshState)refreshState
{
    return _refreshState;
}

- (void)setRefreshState:(RefreshState)refreshState
{
    _refreshState = refreshState;
    switch (_refreshState)
    {
        case SNormal:
            self.stateTextLabel.text = @"下拉加载...";
            self.arrowImageView.image = [UIImage imageNamed:@"arrow1.png"];
            // 回到正常状态，图片恢复旋转
            if (_preState != SNormal)
            {
                [UIView animateWithDuration:0.7
                                 animations:^{
                                     // 旋转180度动画，但是这个迷之角度好奇怪 %>_<%,貌似是累积的
                                     self.arrowImageView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
                                 }];
            }
            [_activityIndicator stopAnimating];
            self.arrowImageView.hidden = NO;
            break;
        case SPullDown:
        
            self.stateTextLabel.text = @"松开后加载...";
            self.arrowImageView.image = [UIImage imageNamed:@"arrow2.png"];
            
        {
            [UIView animateWithDuration:0.7
                             animations:^{
                                 // 旋转180度动画，但是这个迷之角度好奇怪 %>_<%
                                 self.arrowImageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
                             }];
        }
            break;
        case SRun:
            self.stateTextLabel.text = @"正在刷新...";
            self.arrowImageView.hidden = YES;
            [_activityIndicator startAnimating];
            break;
            
        default:
            break;
    }
    _preState = refreshState;
}

@end

@interface FooterView ()
{
    RefreshState _refreshState;
    RefreshState _preState;
}

@property (nonatomic, strong) UIImageView *arrowImageView;                      // 图片
@property (nonatomic, strong) UILabel *stateTextLabel;                     // 文字
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;  // 状态指示器

@end

@implementation FooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 图片(后续加入根据下拉的幅度播放帧动画)
        self.backgroundColor = [UIColor orangeColor];
        self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow1.png"]];
        self.arrowImageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        self.arrowImageView.frame = CGRectMake(frame.size.width / 2 - 15, 0, 30, 30);
        [self addSubview:self.arrowImageView];
        
        // 文字
        self.stateTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, 30)];
        self.stateTextLabel.textAlignment = NSTextAlignmentCenter;
        self.stateTextLabel.textColor = [UIColor blackColor];
        [self addSubview:_stateTextLabel];
        
        // 状态
        self.refreshState = SNormal;
        
        // 指示器(与图片位置重合，互相切换隐藏)
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.frame = CGRectMake(frame.size.width / 2 - 15, 0, 30, 30);
        [self addSubview:_activityIndicator];
        
    }
    return self;
}

- (RefreshState)refreshState
{
    return _refreshState;
}

- (void)setRefreshState:(RefreshState)refreshState
{
    _refreshState = refreshState;
    switch (_refreshState)
    {
        case SNormal:
            self.stateTextLabel.text = @"上拉或点击加载...";
            self.arrowImageView.image = [UIImage imageNamed:@"arrow3.png"];
            // 回到正常状态，图片恢复旋转
            if (_preState != SNormal)
            {
                [UIView animateWithDuration:0.7
                                 animations:^{
                                     // 旋转180度动画，但是这个迷之角度好奇怪 %>_<%,貌似是累积的
                                     self.arrowImageView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
                                 }];
            }

            [_activityIndicator stopAnimating];
            self.arrowImageView.hidden = NO;
            break;
        case SDragUp:
            self.stateTextLabel.text = @"松开后加载...";
            self.arrowImageView.image = [UIImage imageNamed:@"arrow2.png"];
            [UIView beginAnimations:nil context:nil];
            self.arrowImageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            [UIView commitAnimations];
            break;
        case SRun:
            self.stateTextLabel.text = @"正在加载更多...";
            self.arrowImageView.hidden = YES;
            [_activityIndicator startAnimating];
            break;
            
        default:
            break;
    }
    _preState = refreshState;
}

@end
