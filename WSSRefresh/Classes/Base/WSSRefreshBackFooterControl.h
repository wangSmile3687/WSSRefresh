//
//  WSSRefreshBackFooterControl.h
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import "WSSRefreshControl.h"


@interface WSSRefreshBackFooterControl : WSSRefreshControl
@property (nonatomic, assign) CGFloat ignoredScrollViewContentInsetBottom;
+ (instancetype)footerWithRefreshingBlock:(WSSRefreshControlRefreshingBlock)refreshingBlock;
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
- (void)endRefreshingWithNoMoreData;
- (void)resetNoMoreData;
@end

