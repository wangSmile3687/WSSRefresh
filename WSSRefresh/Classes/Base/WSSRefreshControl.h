//
//  WSSRefreshControl.h
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import <UIKit/UIKit.h>
#import "WSSRefreshCategoties.h"

@interface WSSLabel : UILabel
- (void)startAnimating;
- (void)stopAnimating;
@end

/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, WSSRefreshState) {
    /** 普通闲置状态 */
    WSSRefreshStateNone = 0,
    /** 松开就可以进行刷新的状态 */
    WSSRefreshStatePulling,
    /** 正在刷新中的状态 */
    WSSRefreshStateRefreshing,
    /** 即将刷新的状态 */
    WSSRefreshStateWillRefresh,
    /** 所有数据加载完毕，没有更多的数据了 */
    WSSRefreshStateNoMoreData
};
/** 进入刷新状态的回调 */
typedef void (^WSSRefreshControlRefreshingBlock)(void);
/** 开始刷新后的回调(进入刷新状态后的回调) */
typedef void (^WSSRefreshControlBeginRefreshingCompletionBlock)(void);
/** 结束刷新后的回调 */
typedef void (^WSSRefreshControlEndRefreshingCompletionBlock)(void);
@interface WSSRefreshControl : UIView
/** 父控件 */
@property (nonatomic, weak, readonly) UIScrollView  *scrollView;
/** 记录scrollView刚开始的inset */
@property (nonatomic, assign) UIEdgeInsets  scrollViewOriginalInset;
/** 正在刷新的回调 */
@property (nonatomic, copy) WSSRefreshControlRefreshingBlock refreshingBlock;
/** 开始刷新的回调 */
@property (nonatomic, copy) WSSRefreshControlBeginRefreshingCompletionBlock beginRefreshingCompletionBlock;
/** 结束刷新的回调 带动画*/
@property (nonatomic, copy) WSSRefreshControlEndRefreshingCompletionBlock   endRefreshingAnimationCompletionBlock;
/** 结束刷新的回调 */
@property (nonatomic, copy) WSSRefreshControlEndRefreshingCompletionBlock   endRefreshingCompletionBlock;
@property (nonatomic, assign) WSSRefreshState state;
@property (nonatomic, assign, readonly) BOOL refreshing;
@property (nonatomic, assign) CGFloat pullingPercent;
@property (nonatomic, assign) BOOL automaticallyChangeAlpha;
@property (nonatomic, weak) id refreshingTarget;
@property (nonatomic, assign) SEL refreshingAction;
@property (nonatomic, strong) WSSLabel *alertLab;
@property (nonatomic, assign) BOOL horizontalRefreshing;
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action;
- (void)beginRefreshing;
- (void)beginRefreshingWithCompletionBlock:(dispatch_block_t)completionBlock;
- (void)endRefreshing;
- (void)endRefreshingWithCompletionBlock:(dispatch_block_t)completionBlock;
- (void)endRefreshingWithAlerText:(NSString *)alertText withTextColor:(UIColor *)textColor
                  CompletionBlock:(dispatch_block_t)completionBlock;
- (void)executeRefreshingCallback;
- (void)refreshStateDidChange:(WSSRefreshState)state oldState:(WSSRefreshState)oldState NS_REQUIRES_SUPER;
- (void)prepare NS_REQUIRES_SUPER;
- (void)setupSubviews NS_REQUIRES_SUPER;
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;
- (void)scrollViewPanStateDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;
@end

