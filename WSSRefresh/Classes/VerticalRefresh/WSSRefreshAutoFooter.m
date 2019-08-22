//
//  WSSRefreshAutoFooter.m
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import "WSSRefreshAutoFooter.h"
#import "WSSRefreshConst.h"

@interface WSSRefreshAutoFooter ()
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong, readwrite) UILabel   *stateLab;
@property (nonatomic, strong) NSMutableDictionary  *stateTitlesMutDict;
@end
@implementation WSSRefreshAutoFooter
- (void)prepare {
    [super prepare];
    
    self.labLeftInset = WSSRefreshLabelLeftInset;
    [self setTitle:WSSRefreshAutoFooterRefreshingText forState:WSSRefreshStateRefreshing];
    [self setTitle:WSSRefreshAutoFooterNoMoreDataText forState:WSSRefreshStateNoMoreData];
    [self setTitle:WSSRefreshAutoFooterNoneText forState:WSSRefreshStateNone];
    
    self.stateLab.userInteractionEnabled = YES;
    [self.stateLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stateLabelClick)]];
}
- (void)setupSubviews {
    [super setupSubviews];
    
    CGFloat arrowCenterX = self.ws_width * 0.5;
    CGFloat stateWidth = 0.0;
    if (!self.stateLab.hidden) {
        stateWidth = [self getTextWidth:self.stateLab.text withFont:self.stateLab.font];
    }
    if (stateWidth > self.ws_width-20-self.labLeftInset) {
        stateWidth = self.ws_width-20-self.labLeftInset;
    }
    if (stateWidth != 0) {
        arrowCenterX -= stateWidth / 2 + self.labLeftInset;
    }
    CGFloat arrowCenterY = self.ws_height * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = arrowCenter;
    }
    if (stateWidth > 0) {
        self.stateLab.ws_originY = self.ws_height * 0.25;
        self.stateLab.ws_originX = (self.ws_width-stateWidth)/2.0;
        self.stateLab.ws_width = stateWidth;
        self.stateLab.ws_height = self.ws_height * 0.5;
    }
}
- (void)refreshStateDidChange:(WSSRefreshState)state oldState:(WSSRefreshState)oldState {
    [super refreshStateDidChange:state oldState:oldState];
    self.stateLab.text = self.stateTitlesMutDict[@(state)];
    
    if (self.stateLab.hidden && state == WSSRefreshStateRefreshing) {
        self.stateLab.text = nil;
    } else {
        self.stateLab.text = self.stateTitlesMutDict[@(state)];
    }
    if (state == WSSRefreshStateNoMoreData || state == WSSRefreshStateNone) {
        [self.loadingView stopAnimating];
    } else if (state == WSSRefreshStateRefreshing) {
        [self.loadingView startAnimating];
    }
}
#pragma mark - event response
- (void)stateLabelClick {
    if (self.state == WSSRefreshStateNone) {
        self.oneNewPan = YES;
        [self beginRefreshing];
    }
}
#pragma mark - public method
- (void)setTitle:(NSString *)title forState:(WSSRefreshState)state {
    if (title.length == 0) {
        return;
    }
    self.stateTitlesMutDict[@(state)] = title;
    self.stateLab.text = self.stateTitlesMutDict[@(state)];
}
#pragma mark - private method
- (CGFloat)getTextWidth:(NSString *)text withFont:(UIFont *)font{
    CGFloat textWidth = 0.0;
    if (text.length > 0) {
        textWidth = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:@{NSFontAttributeName:font}
                                       context:nil].size.width;
    }
    return textWidth;
}
#pragma mark - getter
- (UILabel *)stateLab {
    if (!_stateLab) {
        _stateLab = [[UILabel alloc] init];
        _stateLab.font = [UIFont boldSystemFontOfSize:14];
        _stateLab.textColor = WSSUIColorFromRGB(0x5A5A5A);
        _stateLab.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _stateLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_stateLab];
    }
    return _stateLab;
}
- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView];
    }
    return _loadingView;
}
- (NSMutableDictionary *)stateTitlesMutDict {
    if (!_stateTitlesMutDict) {
        _stateTitlesMutDict = [NSMutableDictionary new];
    }
    return _stateTitlesMutDict;
}


@end
