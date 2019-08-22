//
//  WSSRefreshHeaderControl.h
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import "WSSRefreshControl.h"


@interface WSSRefreshHeaderControl : WSSRefreshControl
@property (nonatomic, copy) NSString *lastUpdatedTimeKey;
@property (nonatomic, assign) CGFloat ignoredScrollViewContentInsetTop;
@property (nonatomic, strong, readonly) NSDate  *lastUpdatedTime;
+ (instancetype)headerWithRefreshingBlock:(WSSRefreshControlRefreshingBlock)refreshingBlock;
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;
@end

