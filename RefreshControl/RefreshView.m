//
//  RefreshView.m
//  RefreshControl
//
//  Created by yxhe on 16/9/19.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

#import "RefreshView.h"

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 图片(后续加入根据下拉的幅度播放帧动画)
        self.backgroundColor = [UIColor orangeColor];
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow1.png"]];
        self.imageView.frame = CGRectMake(frame.size.width / 2 - 15, 0, 30, 30);
        [self addSubview:_imageView];
        
        // 文字
        self.stateTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        self.stateTextLabel.textAlignment = NSTextAlignmentCenter;
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

- (void)setNormal
{
    
}

- (void)setPullDown
{
    
}

- (void)setRun
{
    
}

@end

@implementation FooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 图片(后续加入根据下拉的幅度播放帧动画)
        self.backgroundColor = [UIColor orangeColor];
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow1.png"]];
        self.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        self.imageView.frame = CGRectMake(frame.size.width / 2 - 15, 0, 30, 30);
        [self addSubview:_imageView];
        
        // 文字
        self.stateTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        self.stateTextLabel.textAlignment = NSTextAlignmentCenter;
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


- (void)setNormal
{
    
}

- (void)setPullDown
{
    
}

- (void)setRun
{
    
}

@end
