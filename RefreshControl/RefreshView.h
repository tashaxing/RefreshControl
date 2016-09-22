//
//  RefreshView.h
//  RefreshControl
//
//  Created by yxhe on 16/9/19.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

// ---- 刷新状态头部和尾部view ---- //
#import <UIKit/UIKit.h>

// 定义刷新状态枚举
typedef enum
{
    SNormal,      // 正常
    SDragUp,      // 上拉
    SPullDown,    // 下拉
    SRun          // 加载
}RefreshState;

// 头部，下拉刷新
@interface HeaderView : UIView

@property (nonatomic, assign) RefreshState refreshState;  // 控件状态

@end

// 尾部，上拉加载
@interface FooterView : UITableViewCell

@property (nonatomic, assign) RefreshState refreshState;  // 控件状态

@end
