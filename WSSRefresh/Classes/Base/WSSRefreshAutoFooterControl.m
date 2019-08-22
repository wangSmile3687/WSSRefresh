//
//  WSSRefreshAutoFooterControl.m
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import "WSSRefreshAutoFooterControl.h"
#import "WSSRefreshConst.h"

@implementation WSSRefreshAutoFooterControl

+ (instancetype)footerWithRefreshingBlock:(WSSRefreshControlRefreshingBlock)refreshingBlock {
    WSSRefreshAutoFooterControl *footer = [[self alloc] init];
    footer.refreshingBlock = refreshingBlock;
    return footer;
}
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    WSSRefreshAutoFooterControl *footer = [[self alloc] init];
    [footer setRefreshingTarget:target refreshingAction:action];
    return footer;
}
- (void)prepare {
    [super prepare];
    self.triggerAutomaticallyRefreshPercent = 1.0;
    self.automaticallyRefresh = YES;
    self.onlyRefreshPerDrag = YES;
}
- (void)setupSubviews {
    [super setupSubviews];
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (self.horizontalRefreshing) {
        self.ws_width = WSSRefreshFooterWidth;
    } else {
        self.ws_height = WSSRefreshFooterHeight;
    }
    if (newSuperview) {
        if (self.horizontalRefreshing) {
            if (self.hidden == NO) {
                self.scrollView.ws_insetRight += self.ws_width;
            }
            self.ws_originX = self.scrollView.ws_contentWidth;
        } else {
            if (self.hidden == NO) {
                self.scrollView.ws_insetBottom += self.ws_height;
            }
            self.ws_originY = self.scrollView.ws_contentHeight;
        }
    } else {
        if (self.horizontalRefreshing) {
            if (self.hidden == NO) {
                self.scrollView.ws_insetRight -= self.ws_width;
            }
        } else {
            if (self.hidden == NO) {
                self.scrollView.ws_insetBottom -= self.ws_height;
            }
        }
    }
}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
    if (self.horizontalRefreshing) {
        self.ws_originX = self.scrollView.ws_contentWidth + self.ignoredScrollViewContentInsetBottom;
    } else {
        self.ws_originY = self.scrollView.ws_contentHeight + self.ignoredScrollViewContentInsetBottom;
    }
}
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    if (self.horizontalRefreshing) {
        if (self.state != WSSRefreshStateNone || !self.automaticallyRefresh || self.ws_originX == 0) return;
        if (self.scrollView.ws_insetLeft + self.scrollView.ws_contentWidth > self.scrollView.ws_width) {
            if (self.scrollView.ws_offsetX >= self.scrollView.ws_contentWidth - self.scrollView.ws_width + self.ws_width * self.triggerAutomaticallyRefreshPercent + self.scrollView.ws_insetRight - self.ws_width) {
                CGPoint old = [change[@"old"] CGPointValue];
                CGPoint new = [change[@"new"] CGPointValue];
                if (new.x <= old.x) return;
                [self beginRefreshing];
            }
        }
    } else {
        if (self.state != WSSRefreshStateNone || !self.automaticallyRefresh || self.ws_originY == 0) return;
        if (self.scrollView.ws_insetTop + self.scrollView.ws_contentHeight > self.scrollView.ws_height) {
            if (self.scrollView.ws_offsetY >= self.scrollView.ws_contentHeight - self.scrollView.ws_height + self.ws_height * self.triggerAutomaticallyRefreshPercent + self.scrollView.ws_insetBottom - self.ws_height) {
                CGPoint old = [change[@"old"] CGPointValue];
                CGPoint new = [change[@"new"] CGPointValue];
                if (new.y <= old.y) return;
                [self beginRefreshing];
            }
        }
    }
}
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
    if (self.state != WSSRefreshStateNone) return;
    UIGestureRecognizerState panState = self.scrollView.panGestureRecognizer.state;
    if (panState == UIGestureRecognizerStateEnded) {
        if (self.horizontalRefreshing) {
            if (self.scrollView.ws_insetLeft + self.scrollView.ws_contentWidth <= self.scrollView.ws_width) {
                if (self.scrollView.ws_offsetX >= - self.scrollView.ws_insetLeft) {
                    [self beginRefreshing];
                }
            } else {
                if (self.scrollView.ws_offsetX >= self.scrollView.ws_contentWidth + self.scrollView.ws_insetRight - self.scrollView.ws_width) {
                    [self beginRefreshing];
                }
            }
        } else {
            if (self.scrollView.ws_insetTop + self.scrollView.ws_contentHeight <= self.scrollView.ws_height) {
                if (self.scrollView.ws_offsetY >= - self.scrollView.ws_insetTop) {
                    [self beginRefreshing];
                }
            } else {
                if (self.scrollView.ws_offsetY >= self.scrollView.ws_contentHeight + self.scrollView.ws_insetBottom - self.scrollView.ws_height) {
                    [self beginRefreshing];
                }
            }
        }
    } else if (panState == UIGestureRecognizerStateBegan) {
        self.oneNewPan = YES;
    }
}

- (void)beginRefreshing{
    if (!self.oneNewPan && self.onlyRefreshPerDrag) return;
    [super beginRefreshing];
    self.oneNewPan = NO;
}
- (void)refreshStateDidChange:(WSSRefreshState)state oldState:(WSSRefreshState)oldState {
    [super refreshStateDidChange:state oldState:oldState];
    if (state == WSSRefreshStateRefreshing) {
        [self executeRefreshingCallback];
    } else if (state == WSSRefreshStateNoMoreData || state == WSSRefreshStateNone) {
        if (oldState != WSSRefreshStateRefreshing) {
            return;
        }
        WSSRefreshDispatchAsyncOnMainQueue({
            if (self.alertLab.alpha == 1.0) {
                [self.alertLab stopAnimating];
            }
            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
            self.endRefreshingCompletionBlock = nil;
        })
    }
}
#pragma mark - public method
- (void)endRefreshingWithNoMoreData {
    WSSRefreshDispatchAsyncOnMainQueue(self.state = WSSRefreshStateNoMoreData)
}
- (void)resetNoMoreData {
    WSSRefreshDispatchAsyncOnMainQueue(self.state = WSSRefreshStateNone)
}
#pragma mark - setter
- (void)setHidden:(BOOL)hidden{
    BOOL lastHidden = self.isHidden;
    [super setHidden:hidden];
    if (!lastHidden && hidden) {
        self.state = WSSRefreshStateNone;
        if (self.horizontalRefreshing) {
            self.scrollView.ws_insetRight -= self.ws_width;
        } else {
            self.scrollView.ws_insetBottom -= self.ws_height;
        }
    } else if (lastHidden && !hidden) {
        if (self.horizontalRefreshing) {
            self.scrollView.ws_insetRight += self.ws_width;
            self.ws_originX = self.scrollView.ws_contentWidth;
        } else {
            self.scrollView.ws_insetBottom += self.ws_height;
            self.ws_originY = self.scrollView.ws_contentHeight;
        }
    }
}


@end
