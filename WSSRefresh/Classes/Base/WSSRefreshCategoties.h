//
//  WSSRefreshCategoties.h
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import <Foundation/Foundation.h>


@interface UIView (WSLayout)
@property (nonatomic, assign) CGFloat ws_originX;
@property (nonatomic, assign) CGFloat ws_originY;
@property (nonatomic, assign) CGFloat ws_width;
@property (nonatomic, assign) CGFloat ws_height;
@property (nonatomic, assign) CGPoint ws_origin;
@property (nonatomic, assign) CGSize  ws_size;
@end

@interface UIScrollView (WSLayout)
@property (nonatomic, readonly) UIEdgeInsets ws_inset;
@property (nonatomic, assign)   CGFloat      ws_insetTop;
@property (nonatomic, assign)   CGFloat      ws_insetBottom;
@property (nonatomic, assign)   CGFloat      ws_insetLeft;
@property (nonatomic, assign)   CGFloat      ws_insetRight;
@property (nonatomic, assign)   CGFloat      ws_offsetX;
@property (nonatomic, assign)   CGFloat      ws_offsetY;
@property (nonatomic, assign)   CGFloat      ws_contentWidth;
@property (nonatomic, assign)   CGFloat      ws_contentHeight;
@end
