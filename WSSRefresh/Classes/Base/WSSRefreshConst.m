//
//  WSSRefreshConst.m
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import "WSSRefreshConst.h"

const CGFloat WSSRefreshLabelLeftInset = 25;
const CGFloat WSSRefreshHeaderHeight = 54.0;
const CGFloat WSSRefreshFooterHeight = 44.0;
const CGFloat WSSRefreshHeaderWidth = 64.0;
const CGFloat WSSRefreshFooterWidth = 64.0;
const CGFloat WSSRefreshFastAnimationDuration = 0.25;
const CGFloat WSSRefreshSlowAnimationDuration = 0.4;

NSString *const WSSRefreshKeyPathContentOffset = @"contentOffset";
NSString *const WSSRefreshKeyPathContentInset = @"contentInset";
NSString *const WSSRefreshKeyPathContentSize = @"contentSize";
NSString *const WSSRefreshKeyPathPanState = @"state";

NSString *const WSSRefreshHeaderLastUpdatedTimeKey = @"WSRefreshHeaderLastUpdatedTimeKey";

NSString *const WSSRefreshHeaderNoneText = @"下拉可以刷新";
NSString *const WSSRefreshHeaderPullingText = @"松开立即刷新";
NSString *const WSSRefreshHeaderRefreshingText = @"正在刷新数据中...";

NSString *const WSSRefreshAutoFooterNoneText = @"点击或上拉加载更多";
NSString *const WSSRefreshAutoFooterRefreshingText = @"正在加载更多的数据...";
NSString *const WSSRefreshAutoFooterNoMoreDataText = @"已经全部加载完毕";

NSString *const WSSRefreshBackFooterNoneText = @"上拉加载更多";
NSString *const WSSRefreshBackFooterPullingText = @"松开立即加载更多";


void WSSLog(NSString *format, ...) {
#ifdef DEBUG
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}
