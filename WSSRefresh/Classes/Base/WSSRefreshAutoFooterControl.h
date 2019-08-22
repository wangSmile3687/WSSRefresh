//
//  WSSRefreshAutoFooterControl.h
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import "WSSRefreshControl.h"


@interface WSSRefreshAutoFooterControl : WSSRefreshControl
@property (nonatomic, assign) CGFloat ignoredScrollViewContentInsetBottom;
@property (nonatomic, assign) BOOL automaticallyRefresh;
@property (nonatomic, assign) BOOL onlyRefreshPerDrag;
@property (nonatomic, assign) BOOL oneNewPan;
@property (nonatomic, assign) CGFloat triggerAutomaticallyRefreshPercent;
+ (instancetype)footerWithRefreshingBlock:(WSSRefreshControlRefreshingBlock)refreshingBlock;
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
- (void)endRefreshingWithNoMoreData;
- (void)resetNoMoreData;
@end

