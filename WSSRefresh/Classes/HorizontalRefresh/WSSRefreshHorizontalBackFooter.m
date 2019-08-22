//
//  WSSRefreshHorizontalBackFooter.m
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import "WSSRefreshHorizontalBackFooter.h"
#import "WSSRefreshConst.h"
@interface WSSRefreshHorizontalBackFooter ()
@property (nonatomic, strong, readwrite) UIImageView *arrowImgView;
@property (nonatomic, strong, readwrite) UIActivityIndicatorView *loadingView;
@end
@implementation WSSRefreshHorizontalBackFooter
- (void)prepare {
    self.horizontalRefreshing = YES;
    [super prepare];
}
- (void)setupSubviews {
    [super setupSubviews];
    
    CGFloat arrowCenterX = self.ws_width * 0.5;
    CGFloat arrowCenterY = self.ws_height * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    if (self.arrowImgView.constraints.count == 0) {
        self.arrowImgView.ws_size = self.arrowImgView.image.size;
        self.arrowImgView.center = arrowCenter;
    }
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = arrowCenter;
    }
}
- (void)refreshStateDidChange:(WSSRefreshState)state oldState:(WSSRefreshState)oldState {
    [super refreshStateDidChange:state oldState:oldState];
    if (state == WSSRefreshStateNone) {
        if (oldState == WSSRefreshStateRefreshing) {
            self.arrowImgView.transform = CGAffineTransformMakeRotation(M_PI);
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
                self.arrowImgView.transform = CGAffineTransformMakeRotation(M_PI);
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
#pragma mark - private method
- (UIImage *)getImageWithImageName:(NSString *)imageName {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"HorizontalRefresh" ofType:@"bundle"]];
    NSString *path = [bundle pathForResource:[NSString stringWithFormat:@"%@@%zdx",imageName,(NSInteger)[UIScreen mainScreen].scale] ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}
#pragma mark - getter
- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] initWithImage:[self getImageWithImageName:@"horizontalArrow"]];
        _arrowImgView.transform = CGAffineTransformMakeRotation(M_PI);
        [self addSubview:_arrowImgView];
    }
    return _arrowImgView;
}
- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView];
    }
    return _loadingView;
}


@end
