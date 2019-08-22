//
//  WSSRefreshHeaderControl.m
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import "WSSRefreshHeaderControl.h"
#import "WSSRefreshConst.h"

@interface WSSRefreshHeaderControl ()
@property (nonatomic, assign) CGFloat   insetTDetal;
@end
@implementation WSSRefreshHeaderControl
+ (instancetype)headerWithRefreshingBlock:(WSSRefreshControlRefreshingBlock)refreshingBlock {
    WSSRefreshHeaderControl *header = [[self alloc] init];
    header.refreshingBlock = refreshingBlock;
    return header;
}
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    WSSRefreshHeaderControl *header = [[self alloc] init];
    [header setRefreshingTarget:target refreshingAction:action];
    return header;
}
- (void)prepare {
    [super prepare];
    self.lastUpdatedTimeKey = WSSRefreshHeaderLastUpdatedTimeKey;
}
- (void)setupSubviews {
    [super setupSubviews];
    if (self.horizontalRefreshing) {
        self.ws_width = WSSRefreshHeaderWidth;
        self.ws_originX = -self.ws_width - self.ignoredScrollViewContentInsetTop;
    } else {
        self.ws_height = WSSRefreshHeaderHeight;
        self.ws_originY = -self.ws_height - self.ignoredScrollViewContentInsetTop;
    }
}
- (void)resetInset {
    if (@available(iOS 11.0, *)) {
    } else {
        if (!self.window) { return; }
    }
    if (self.horizontalRefreshing) {
        CGFloat insetL = -self.scrollView.ws_offsetX > self.scrollViewOriginalInset.left ? -self.scrollView.ws_offsetX : self.scrollViewOriginalInset.left;
        insetL = insetL > self.ws_width + self.scrollViewOriginalInset.left ? self.ws_width + self.scrollViewOriginalInset.left : insetL;
        self.scrollView.ws_insetLeft = insetL;
        self.insetTDetal = self.scrollViewOriginalInset.left - insetL;
    } else {
        CGFloat insetT = -self.scrollView.ws_offsetY > self.scrollViewOriginalInset.top ? -self.scrollView.ws_offsetY : self.scrollViewOriginalInset.top;
        insetT = insetT > self.ws_height + self.scrollViewOriginalInset.top ? self.ws_height + self.scrollViewOriginalInset.top : insetT;
        self.scrollView.ws_insetTop = insetT;
        self.insetTDetal = self.scrollViewOriginalInset.top - insetT;
    }
}
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    if (self.state == WSSRefreshStateRefreshing) {
        [self resetInset];
        return;
    }
    self.scrollViewOriginalInset = self.scrollView.ws_inset;
    CGFloat offsetY = 0.0;
    CGFloat happenOffsetY = 0.0;
    if (self.horizontalRefreshing) {
        offsetY = self.scrollView.ws_offsetX;
        happenOffsetY = -self.scrollViewOriginalInset.left;
    } else {
        offsetY = self.scrollView.ws_offsetY;
        happenOffsetY = -self.scrollViewOriginalInset.top;
    }
    if (offsetY > happenOffsetY) {
        return;
    }
    CGFloat normalPullingOffsetY = 0.0;
    CGFloat pullingPercent = 0.0;
    if (self.horizontalRefreshing) {
        normalPullingOffsetY = happenOffsetY - self.ws_width;
        pullingPercent = (happenOffsetY - offsetY) / self.ws_width;
    } else {
        normalPullingOffsetY = happenOffsetY - self.ws_height;
        pullingPercent = (happenOffsetY - offsetY) / self.ws_height;
    }
    if (self.scrollView.isDragging) {
        self.pullingPercent = pullingPercent;
        if (self.state == WSSRefreshStateNone && offsetY < normalPullingOffsetY) {
            self.state = WSSRefreshStatePulling;
        } else if (self.state == WSSRefreshStatePulling &&offsetY >= normalPullingOffsetY) {
            self.state = WSSRefreshStateNone;
        }
    } else if (self.state == WSSRefreshStatePulling) {
        [self beginRefreshing];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}
- (void)refreshStateDidChange:(WSSRefreshState)state oldState:(WSSRefreshState)oldState {
    [super refreshStateDidChange:state oldState:oldState];
    if (state == WSSRefreshStateNone) {
        if (oldState != WSSRefreshStateRefreshing) {
            return;
        }
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.lastUpdatedTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        WSSRefreshDispatchAsyncOnMainQueue({
            [UIView animateWithDuration:WSSRefreshSlowAnimationDuration animations:^{
                if (self.horizontalRefreshing) {
                    self.scrollView.ws_insetLeft += self.insetTDetal;
                } else {
                    self.scrollView.ws_insetTop += self.insetTDetal;
                }
                if (self.automaticallyChangeAlpha) {
                    self.alpha = 0.0;
                }
            } completion:^(BOOL finished) {
                if (self.alertLab.alpha == 1.0) {
                    [self.alertLab stopAnimating];
                }
                self.pullingPercent = 0.0;
                if (self.endRefreshingCompletionBlock) {
                    self.endRefreshingCompletionBlock();
                }
                self.endRefreshingCompletionBlock = nil;
            }];
        })
    } else if (state == WSSRefreshStateRefreshing) {
        WSSRefreshDispatchAsyncOnMainQueue({
            [UIView animateWithDuration:WSSRefreshFastAnimationDuration animations:^{
                if (self.scrollView.panGestureRecognizer.state != UIGestureRecognizerStateCancelled) {
                    if (self.horizontalRefreshing) {
                        CGFloat left = self.scrollViewOriginalInset.left + self.ws_width;
                        self.scrollView.ws_insetLeft = left;
                        CGPoint offset = self.scrollView.contentOffset;
                        offset.x = -left;
                        [self.scrollView setContentOffset:offset animated:NO];
                    } else {
                        CGFloat top = self.scrollViewOriginalInset.top + self.ws_height;
                        self.scrollView.ws_insetTop = top;
                        CGPoint offset = self.scrollView.contentOffset;
                        offset.y = -top;
                        [self.scrollView setContentOffset:offset animated:NO];
                    }
                }
            } completion:^(BOOL finished) {
                [self executeRefreshingCallback];
            }];
        })
    }
}
#pragma mark - public method
- (NSDate *)lastUpdatedTime {
    return [[NSUserDefaults standardUserDefaults] objectForKey:self.lastUpdatedTimeKey];
}
- (void)setIgnoredScrollViewContentInsetTop:(CGFloat)ignoredScrollViewContentInsetTop {
    _ignoredScrollViewContentInsetTop = ignoredScrollViewContentInsetTop;
    
    if (self.horizontalRefreshing) {
        self.ws_originX = - self.ws_width - ignoredScrollViewContentInsetTop;
    } else {
        self.ws_originY = - self.ws_height - ignoredScrollViewContentInsetTop;
    }
}
@end
