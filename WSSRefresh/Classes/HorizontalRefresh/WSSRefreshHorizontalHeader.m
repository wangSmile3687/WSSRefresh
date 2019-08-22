//
//  WSSRefreshHorizontalHeader.m
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import "WSSRefreshHorizontalHeader.h"
#import "WSSRefreshConst.h"
@interface WSSRefreshHorizontalHeader ()
@property (nonatomic, strong, readwrite) UIImageView *arrowImgView;
@property (nonatomic, strong, readwrite) UIActivityIndicatorView *loadingView;
@end
@implementation WSSRefreshHorizontalHeader
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
#pragma mark - public method

- (void)refreshStateDidChange:(WSSRefreshState)state oldState:(WSSRefreshState)oldState {
    [super refreshStateDidChange:state oldState:oldState];
    
    if (state == WSSRefreshStateNone) {
        if (oldState == WSSRefreshStateRefreshing) {
            self.arrowImgView.transform = CGAffineTransformIdentity;
            [self.loadingView stopAnimating];
            self.loadingView.alpha = 0.0;
            self.arrowImgView.hidden = NO;
        } else {
            [self.loadingView stopAnimating];
            self.loadingView.alpha = 0.0;
            self.arrowImgView.hidden = NO;
            [UIView animateWithDuration:WSSRefreshFastAnimationDuration animations:^{
                self.arrowImgView.transform = CGAffineTransformIdentity;
            }];
        }
    } else if (state == WSSRefreshStatePulling) {
        [self.loadingView stopAnimating];
        self.arrowImgView.hidden = NO;
        [UIView animateWithDuration:WSSRefreshFastAnimationDuration animations:^{
            self.arrowImgView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    } else if (state == WSSRefreshStateRefreshing) {
        self.loadingView.alpha = 1.0;
        [self.loadingView startAnimating];
        self.arrowImgView.hidden = YES;
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
