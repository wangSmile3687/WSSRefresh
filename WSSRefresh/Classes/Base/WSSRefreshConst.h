//
//  WSSRefreshConst.h
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import <Foundation/Foundation.h>


#import <objc/message.h>

#define WSSRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define WSSRefreshMsgTarget(target) (__bridge void *)(target)

#define WSSWeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define WSSStrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

#define WSSUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


UIKIT_EXTERN const CGFloat WSSRefreshLabelLeftInset;
UIKIT_EXTERN const CGFloat WSSRefreshHeaderHeight;
UIKIT_EXTERN const CGFloat WSSRefreshFooterHeight;
UIKIT_EXTERN const CGFloat WSSRefreshHeaderWidth;
UIKIT_EXTERN const CGFloat WSSRefreshFooterWidth;
UIKIT_EXTERN const CGFloat WSSRefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat WSSRefreshSlowAnimationDuration;

UIKIT_EXTERN NSString *const WSSRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const WSSRefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const WSSRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const WSSRefreshKeyPathPanState;

UIKIT_EXTERN NSString *const WSSRefreshHeaderLastUpdatedTimeKey;

UIKIT_EXTERN NSString *const WSSRefreshHeaderNoneText;
UIKIT_EXTERN NSString *const WSSRefreshHeaderPullingText;
UIKIT_EXTERN NSString *const WSSRefreshHeaderRefreshingText;

UIKIT_EXTERN NSString *const WSSRefreshAutoFooterNoneText;
UIKIT_EXTERN NSString *const WSSRefreshAutoFooterRefreshingText;
UIKIT_EXTERN NSString *const WSSRefreshAutoFooterNoMoreDataText;

UIKIT_EXTERN NSString *const WSSRefreshBackFooterNoneText;
UIKIT_EXTERN NSString *const WSSRefreshBackFooterPullingText;

FOUNDATION_EXPORT void WSSLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

#define WSSRefreshDispatchAsyncOnMainQueue(x) \
__weak typeof(self) weakSelf = self; \
dispatch_async(dispatch_get_main_queue(), ^{ \
typeof(weakSelf) self = weakSelf; \
{x;} \
});


