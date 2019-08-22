//
//  UIScrollView+WSSRefresh.h
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import <UIKit/UIKit.h>

@class WSSRefreshHeaderControl;
@class WSSRefreshAutoFooterControl;
@class WSSRefreshBackFooterControl;
@interface UIScrollView (WSSRefresh)
@property (nonatomic, strong) WSSRefreshHeaderControl *ws_refreshHeader;
@property (nonatomic, strong) WSSRefreshAutoFooterControl *ws_refreshAutoFooter;
@property (nonatomic, strong) WSSRefreshBackFooterControl *ws_refreshBackFooter;
@end

