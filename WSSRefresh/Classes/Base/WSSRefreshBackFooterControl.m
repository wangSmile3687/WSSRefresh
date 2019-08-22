//
//  WSSRefreshBackFooterControl.m
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import "WSSRefreshBackFooterControl.h"
#import "WSSRefreshConst.h"

@interface WSSRefreshBackFooterControl ()
@property (nonatomic, assign) CGFloat lastBottomDelta;
@end
@implementation WSSRefreshBackFooterControl
+ (instancetype)footerWithRefreshingBlock:(WSSRefreshControlRefreshingBlock)refreshingBlock {
    WSSRefreshBackFooterControl *footer = [[self alloc] init];
    footer.refreshingBlock = refreshingBlock;
    return footer;
}
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    WSSRefreshBackFooterControl *footer = [[self alloc] init];
    [footer setRefreshingTarget:target refreshingAction:action];
    return footer;
}
- (void)setupSubviews {
    [super setupSubviews];
    if (self.horizontalRefreshing) {
        self.ws_width = WSSRefreshFooterWidth;
    } else {
        self.ws_height = WSSRefreshFooterHeight;
    }
}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
    if (self.horizontalRefreshing) {
        CGFloat contentWidth = self.scrollView.ws_contentWidth + self.ignoredScrollViewContentInsetBottom;
        CGFloat scrollWidth = self.scrollView.ws_width - self.scrollViewOriginalInset.left - self.scrollViewOriginalInset.right + self.ignoredScrollViewContentInsetBottom;
        self.ws_originX = MAX(contentWidth, scrollWidth);
    } else {
        CGFloat contentHeight = self.scrollView.ws_contentHeight + self.ignoredScrollViewContentInsetBottom;
        CGFloat scrollHeight = self.scrollView.ws_height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom + self.ignoredScrollViewContentInsetBottom;
        self.ws_originY = MAX(contentHeight, scrollHeight);
    }
}
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    if (self.state == WSSRefreshStateRefreshing) return;
    self.scrollViewOriginalInset = self.scrollView.ws_inset;
    CGFloat currentOffsetY = 0.0;
    CGFloat happenOffsetY = 0.0;
    if (self.horizontalRefreshing) {
        currentOffsetY = self.scrollView.ws_offsetX;
        happenOffsetY = [self happenOffsetY];
    } else {
        currentOffsetY = self.scrollView.ws_offsetY;
        happenOffsetY = [self happenOffsetY];
    }
    if (currentOffsetY <= happenOffsetY) return;
    CGFloat pullingPercent = 0.0;
    if (self.horizontalRefreshing) {
        pullingPercent = (currentOffsetY - happenOffsetY) / self.ws_width;
    } else {
        pullingPercent = (currentOffsetY - happenOffsetY) / self.ws_height;
    }
    if (self.state == WSSRefreshStateNoMoreData) {
        self.pullingPercent = pullingPercent;
        return;
    }
    if (self.scrollView.isDragging) {
        self.pullingPercent = pullingPercent;
        CGFloat normalPullingOffsetY = 0.0;
        if (self.horizontalRefreshing) {
            normalPullingOffsetY = happenOffsetY + self.ws_width;
        } else {
            normalPullingOffsetY = happenOffsetY + self.ws_height;
        }
        if (self.state == WSSRefreshStateNone && currentOffsetY > normalPullingOffsetY) {
            self.state = WSSRefreshStatePulling;
        } else if (self.state == WSSRefreshStatePulling && currentOffsetY <= normalPullingOffsetY) {
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
    if (state == WSSRefreshStateNoMoreData || state == WSSRefreshStateNone) {
        if (WSSRefreshStateRefreshing == oldState) {
            WSSRefreshDispatchAsyncOnMainQueue({
                [UIView animateWithDuration:WSSRefreshSlowAnimationDuration animations:^{
                    if (self.horizontalRefreshing) {
                        self.scrollView.ws_insetRight = self.scrollView.ws_insetRight;
                    } else {
                        self.scrollView.ws_insetBottom = self.scrollView.ws_insetBottom;
                    }
                    if (self.automaticallyChangeAlpha) self.alpha = 0.0;
                } completion:^(BOOL finished) {
                    if (self.alertLab.alpha == 1.0) {
                        [self.alertLab stopAnimating];
                    }
                    if (self.horizontalRefreshing) {
                        self.scrollView.ws_insetRight -= self.lastBottomDelta;
                    } else {
                        self.scrollView.ws_insetBottom -= self.lastBottomDelta;
                    }
                    self.pullingPercent = 0.0;
                    if (self.endRefreshingCompletionBlock) {
                        self.endRefreshingCompletionBlock();
                    }
                    self.endRefreshingCompletionBlock = nil;
                }];
            })
        }
    } else if (state == WSSRefreshStateRefreshing) {
        WSSRefreshDispatchAsyncOnMainQueue({
            [UIView animateWithDuration:WSSRefreshFastAnimationDuration animations:^{
                if (self.horizontalRefreshing) {
                    CGFloat right = self.ws_width + self.scrollViewOriginalInset.right;
                    CGFloat deltaW = [self heightForContentBreakView];
                    if (deltaW < 0) {
                        right -= deltaW;
                    }
                    self.lastBottomDelta = right - self.scrollView.ws_insetRight;
                    self.scrollView.ws_insetRight = right;
                    self.scrollView.ws_offsetX= [self happenOffsetY] + self.ws_width;
                } else {
                    CGFloat bottom = self.ws_height + self.scrollViewOriginalInset.bottom;
                    CGFloat deltaH = [self heightForContentBreakView];
                    if (deltaH < 0) {
                        bottom -= deltaH;
                    }
                    self.lastBottomDelta = bottom - self.scrollView.ws_insetBottom;
                    self.scrollView.ws_insetBottom = bottom;
                    self.scrollView.ws_offsetY = [self happenOffsetY] + self.ws_height;
                }
            } completion:^(BOOL finished) {
                [self executeRefreshingCallback];
            }];
        })
    }
}
#pragma mark - private method
- (CGFloat)heightForContentBreakView {
    if (self.horizontalRefreshing) {
        CGFloat w = self.scrollView.frame.size.width - self.scrollViewOriginalInset.right - self.scrollViewOriginalInset.left;
        return self.scrollView.contentSize.width - w;
    } else {
        CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
        return self.scrollView.contentSize.height - h;
    }
}
- (CGFloat)happenOffsetY {
    CGFloat deltaH = [self heightForContentBreakView];
    if (self.horizontalRefreshing) {
        if (deltaH > 0) {
            return deltaH - self.scrollViewOriginalInset.left;
        } else {
            return - self.scrollViewOriginalInset.left;
        }
    } else {
        if (deltaH > 0) {
            return deltaH - self.scrollViewOriginalInset.top;
        } else {
            return - self.scrollViewOriginalInset.top;
        }
    }
}
#pragma mark - public method
- (void)endRefreshingWithNoMoreData {
    WSSRefreshDispatchAsyncOnMainQueue(self.state = WSSRefreshStateNoMoreData)
}
- (void)resetNoMoreData {
    WSSRefreshDispatchAsyncOnMainQueue(self.state = WSSRefreshStateNone)
}
@end
