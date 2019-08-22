//
//  WSSRefreshBackFooter.m
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import "WSSRefreshBackFooter.h"
#import "WSSRefreshConst.h"

@interface WSSRefreshBackFooter ()
@property (nonatomic, strong, readwrite) UILabel   *stateLab;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) NSMutableDictionary  *stateTitlesMutDict;
@end
@implementation WSSRefreshBackFooter
- (void)prepare {
    [super prepare];
    
    self.labLeftInset = WSSRefreshLabelLeftInset;
    [self setTitle:WSSRefreshBackFooterPullingText forState:WSSRefreshStatePulling];
    [self setTitle:WSSRefreshAutoFooterRefreshingText forState:WSSRefreshStateRefreshing];
    [self setTitle:WSSRefreshAutoFooterNoMoreDataText forState:WSSRefreshStateNoMoreData];
    [self setTitle:WSSRefreshBackFooterNoneText forState:WSSRefreshStateNone];
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
    self.arrowImgView.tintColor = self.stateLab.textColor;
    if (self.arrowImgView.constraints.count == 0) {
        self.arrowImgView.ws_size = self.arrowImgView.image.size;
        self.arrowImgView.center = arrowCenter;
    }
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
    if (state == WSSRefreshStateNone) {
        if (oldState == WSSRefreshStateRefreshing) {
            self.arrowImgView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            [UIView animateWithDuration:WSSRefreshSlowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                if (state != WSSRefreshStateNone) return;
                self.loadingView.alpha = 1.0;
                [self.loadingView stopAnimating];
                self.arrowImgView.hidden = NO;
            }];
        } else {
            self.arrowImgView.hidden = NO;
            [self.loadingView stopAnimating];
            [UIView animateWithDuration:WSSRefreshFastAnimationDuration animations:^{
                self.arrowImgView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            }];
        }
    } else if (state == WSSRefreshStatePulling) {
        self.arrowImgView.hidden = NO;
        [self.loadingView stopAnimating];
        [UIView animateWithDuration:WSSRefreshFastAnimationDuration animations:^{
            self.arrowImgView.transform = CGAffineTransformIdentity;
        }];
    } else if (state == WSSRefreshStateRefreshing) {
        self.arrowImgView.hidden = YES;
        [self.loadingView startAnimating];
    } else if (state == WSSRefreshStateNoMoreData) {
        self.arrowImgView.hidden = YES;
        [self.loadingView stopAnimating];
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
- (UIImage *)getImageWithImageName:(NSString *)imageName {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"VerticalRefresh" ofType:@"bundle"]];
    NSString *path = [bundle pathForResource:[NSString stringWithFormat:@"%@@%zdx",imageName,(NSInteger)[UIScreen mainScreen].scale] ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}
#pragma mark - getter
- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] initWithImage:[self getImageWithImageName:@"arrow"]];
        _arrowImgView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        [self addSubview:_arrowImgView];
    }
    return _arrowImgView;
}
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
