//
//  WSSRefreshHorizontalAutoFooter.m
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import "WSSRefreshHorizontalAutoFooter.h"

@interface WSSRefreshHorizontalAutoFooter ()
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@end
@implementation WSSRefreshHorizontalAutoFooter
- (void)prepare {
    self.horizontalRefreshing = YES;
    [super prepare];
}
- (void)setupSubviews {
    [super setupSubviews];
    
    CGFloat arrowCenterX = self.ws_width * 0.5;
    CGFloat arrowCenterY = self.ws_height * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = arrowCenter;
    }
}
- (void)refreshStateDidChange:(WSSRefreshState)state oldState:(WSSRefreshState)oldState {
    [super refreshStateDidChange:state oldState:oldState];
    if (state == WSSRefreshStateNoMoreData || state == WSSRefreshStateNone) {
        [self.loadingView stopAnimating];
    } else if (state == WSSRefreshStateRefreshing) {
        [self.loadingView startAnimating];
    }
}
#pragma mark - getter
- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView];
    }
    return _loadingView;
}

@end
