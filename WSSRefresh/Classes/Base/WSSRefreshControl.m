//
//  WSSRefreshControl.m
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import "WSSRefreshControl.h"
#import "WSSRefreshConst.h"

@interface WSSLabel ()<CAAnimationDelegate>
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, assign) BOOL horizontal;
@end
@implementation WSSLabel
- (instancetype)initWithFrame:(CGRect)frame withHorizontal:(BOOL)horizontal{
    if (self = [super initWithFrame:frame]) {
        self.horizontal = horizontal;
        self.layer.masksToBounds = YES;
        [self.layer addSublayer:self.gradientLayer];
    }
    return self;
}
- (void)layoutSubviews{
    if (self.horizontal) {
        _gradientLayer.frame = CGRectMake(0, 0, self.ws_width, 0);
    } else {
        _gradientLayer.frame = CGRectMake(0, 0, 0, self.ws_height);
    }
    _gradientLayer.position = CGPointMake(self.ws_width/2.0, self.ws_height/2.0);
}
- (void)startAnimating{
    self.alpha = 1.0;
    _gradientLayer.colors = @[(id)[self.textColor colorWithAlphaComponent:0.2].CGColor,
                              (id)[self.textColor colorWithAlphaComponent:0.1].CGColor,
                              (id)[self.textColor colorWithAlphaComponent:0.2].CGColor];
    CABasicAnimation *animation;
    if (self.horizontal) {
        animation = [CABasicAnimation animationWithKeyPath:@"bounds.size.height"];
        animation.fromValue = @(0);
        animation.toValue = @(self.ws_height);
    } else {
        animation = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
        animation.fromValue = @(0);
        animation.toValue = @(self.ws_width);
    }
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 0.3;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    [_gradientLayer addAnimation:animation forKey:animation.keyPath];
}
- (void)stopAnimating{
    self.text = nil;
    self.alpha = 0.0;
    [_gradientLayer removeAllAnimations];
}
#pragma mark - getter
- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer new];
        _gradientLayer.locations = @[@0.2,@0.5,@0.8];
        if (self.horizontal) {
            _gradientLayer.startPoint = CGPointMake(0.5, 0);
            _gradientLayer.endPoint = CGPointMake(0.5, 1);
        } else {
            _gradientLayer.startPoint = CGPointMake(0, 0.5);
            _gradientLayer.endPoint = CGPointMake(1, 0.5);
        }
    }
    return _gradientLayer;
}
@end

@interface WSSRefreshControl ()
@property (nonatomic, weak, readwrite) UIScrollView  *scrollView;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) BOOL firstLoad;
@end
@implementation WSSRefreshControl
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.firstLoad = YES;
        [self prepare];
        self.state = WSSRefreshStateNone;
    }
    return self;
}
- (void)dealloc {
    WSSLog(@"----dealloc----------WSSRereshControl------------");
}
- (void)layoutSubviews {
    [self setupSubviews];
    [super layoutSubviews];
    
    _alertLab.frame = self.bounds;
}
- (void)prepare {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
}
- (void)setupSubviews {
    if (self.firstLoad) {
        [self addSubview:self.alertLab];
        self.firstLoad = NO;
    }
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    [self removeObservers];
    if (newSuperview) {
        _scrollView = (UIScrollView *)newSuperview;
        if (self.horizontalRefreshing) {
            self.ws_height = _scrollView.ws_height;
            self.ws_originY = -_scrollView.ws_insetTop;
            _scrollView.alwaysBounceHorizontal = YES;
        } else {
            self.ws_width = _scrollView.ws_width;
            self.ws_originX = -_scrollView.ws_insetLeft;
            _scrollView.alwaysBounceVertical = YES;
        }
        _scrollViewOriginalInset = _scrollView.ws_inset;
        [self addObservers];
    }
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.state == WSSRefreshStateWillRefresh) {
        self.state = WSSRefreshStateRefreshing;
    }
}
#pragma mark - kvo
- (void)addObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [_scrollView addObserver:self forKeyPath:WSSRefreshKeyPathContentOffset options:options context:nil];
    [_scrollView addObserver:self forKeyPath:WSSRefreshKeyPathContentSize options:options context:nil];
    _pan = _scrollView.panGestureRecognizer;
    [_pan addObserver:self forKeyPath:WSSRefreshKeyPathPanState options:options context:nil];
}
- (void)removeObservers {
    [_scrollView removeObserver:self forKeyPath:WSSRefreshKeyPathContentOffset];
    [_scrollView removeObserver:self forKeyPath:WSSRefreshKeyPathContentSize];
    [_pan removeObserver:self forKeyPath:WSSRefreshKeyPathPanState];
    _pan = nil;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (!self.userInteractionEnabled) {
        return;
    }
    if ([keyPath isEqualToString:WSSRefreshKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    if (self.hidden) {
        return;
    }
    if ([keyPath isEqualToString:WSSRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if ([keyPath isEqualToString:WSSRefreshKeyPathPanState]) {
        [self scrollViewPanStateDidChange:change];
    }
}
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {}
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {}
#pragma mark - public method
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action {
    self.refreshingTarget = target;
    self.refreshingAction = action;
}
- (void)refreshStateDidChange:(WSSRefreshState)state oldState:(WSSRefreshState)oldState {}
#pragma mark - begin refreshing
- (void)beginRefreshing {
    [self beginRefreshingWithCompletionBlock:nil];
}
- (void)beginRefreshingWithCompletionBlock:(dispatch_block_t)completionBlock {
    self.beginRefreshingCompletionBlock = completionBlock;
    [UIView animateWithDuration:WSSRefreshFastAnimationDuration animations:^{
        self.alpha = 1.0;
    }];
    self.pullingPercent = 1.0;
    if (self.window) {
        self.state = WSSRefreshStateRefreshing;
    } else {
        if (self.state != WSSRefreshStateRefreshing) {
            self.state = WSSRefreshStateWillRefresh;
            [self setNeedsDisplay];
        }
    }
}
#pragma mark - end refreshing
- (void)endRefreshing {
    [self endRefreshingWithAlerText:nil withTextColor:nil CompletionBlock:nil];
}
- (void)endRefreshingWithCompletionBlock:(dispatch_block_t)completionBlock {
    [self endRefreshingWithAlerText:nil withTextColor:nil CompletionBlock:completionBlock];
}
- (void)endRefreshingWithAlerText:(NSString *)alertText withTextColor:(UIColor *)textColor CompletionBlock:(dispatch_block_t)completionBlock {
    self.endRefreshingCompletionBlock = completionBlock;
    if (alertText.length > 0) {
        _alertLab.text = alertText;
        _alertLab.textColor = textColor;
        [self bringSubviewToFront:self.alertLab];
        [self.alertLab startAnimating];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            WSSRefreshDispatchAsyncOnMainQueue(self.state = WSSRefreshStateNone)
        });
    } else {
        WSSRefreshDispatchAsyncOnMainQueue(self.state = WSSRefreshStateNone)
    }
}
#pragma mark -  method
- (void)executeRefreshingCallback {
    WSSRefreshDispatchAsyncOnMainQueue({
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
        if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
            WSSRefreshMsgSend(WSSRefreshMsgTarget(self.refreshingTarget),self.refreshingAction,self);
        }
        if (self.beginRefreshingCompletionBlock) {
            self.beginRefreshingCompletionBlock();
        }
        self.beginRefreshingCompletionBlock = nil;
    })
}
#pragma mark - setter
- (void)setAutomaticallyChangeAlpha:(BOOL)automaticallyChangeAlpha {
    _automaticallyChangeAlpha = automaticallyChangeAlpha;
    if (self.refreshing) {
        return;
    }
    if (automaticallyChangeAlpha) {
        self.alpha = self.pullingPercent;
    } else {
        self.alpha = 1.0;
    }
}
- (void)setPullingPercent:(CGFloat)pullingPercent {
    _pullingPercent = pullingPercent;
    if (self.refreshing) {
        return;
    }
    if (self.automaticallyChangeAlpha) {
        self.alpha = pullingPercent;
    }
}
- (void)setState:(WSSRefreshState)state {
    WSSRefreshState oldState = self.state;
    if (state == oldState) {
        return;
    }
    _state = state;
    WSSRefreshDispatchAsyncOnMainQueue([self setNeedsLayout];)
    [self refreshStateDidChange:state oldState:oldState];
}
#pragma mark - getter
- (BOOL)refreshing {
    return self.state == WSSRefreshStateRefreshing || self.state == WSSRefreshStateWillRefresh;
}
- (WSSLabel *)alertLab {
    if (!_alertLab) {
        _alertLab = [[WSSLabel alloc] initWithFrame:CGRectZero withHorizontal:self.horizontalRefreshing];
        _alertLab.textAlignment = NSTextAlignmentCenter;
        _alertLab.font =  [UIFont fontWithName:@"Helvetica" size:15.f];
        _alertLab.alpha = 0.0;
        _alertLab.backgroundColor = [UIColor whiteColor];
        _alertLab.numberOfLines = 0;
    }
    return _alertLab;
}
@end
