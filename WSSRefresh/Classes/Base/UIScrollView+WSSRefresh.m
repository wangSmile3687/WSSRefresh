//
//  UIScrollView+WSSRefresh.m
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import "UIScrollView+WSSRefresh.h"
#import "WSSRefreshHeaderControl.h"
#import "WSSRefreshAutoFooterControl.h"
#import "WSSRefreshBackFooterControl.h"
#import <objc/runtime.h>

const void *WSSRefreshHeaderKey = &WSSRefreshHeaderKey;
const void *WSSRefreshAutoFooterKey = &WSSRefreshAutoFooterKey;
const void *WSSRefreshBackFooterKey = &WSSRefreshBackFooterKey;

@implementation UIScrollView (WSSRefresh)
- (void)setWs_refreshHeader:(WSSRefreshHeaderControl *)ws_refreshHeader {
    if (ws_refreshHeader != self.ws_refreshHeader) {
        [self.ws_refreshHeader removeFromSuperview];
        [self insertSubview:ws_refreshHeader atIndex:0];
        objc_setAssociatedObject(self, WSSRefreshHeaderKey, ws_refreshHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
- (WSSRefreshHeaderControl *)ws_refreshHeader {
    return objc_getAssociatedObject(self, WSSRefreshHeaderKey);
}
- (void)setWs_refreshAutoFooter:(WSSRefreshAutoFooterControl *)ws_refreshAutoFooter {
    if (ws_refreshAutoFooter != self.ws_refreshAutoFooter) {
        [self.ws_refreshAutoFooter removeFromSuperview];
        [self insertSubview:ws_refreshAutoFooter atIndex:0];
        objc_setAssociatedObject(self, WSSRefreshAutoFooterKey, ws_refreshAutoFooter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
- (WSSRefreshAutoFooterControl *)ws_refreshAutoFooter {
    return objc_getAssociatedObject(self, WSSRefreshAutoFooterKey);
}
- (void)setWs_refreshBackFooter:(WSSRefreshBackFooterControl *)ws_refreshBackFooter {
    if (ws_refreshBackFooter != self.ws_refreshBackFooter) {
        [self.ws_refreshBackFooter removeFromSuperview];
        [self insertSubview:ws_refreshBackFooter atIndex:0];
        objc_setAssociatedObject(self, WSSRefreshBackFooterKey, ws_refreshBackFooter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
- (WSSRefreshBackFooterControl *)ws_refreshBackFooter {
    return objc_getAssociatedObject(self, WSSRefreshBackFooterKey);
}
@end
