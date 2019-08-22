//
//  WSSRefreshCategoties.m
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import "WSSRefreshCategoties.h"

@implementation UIView (WSLayout)
- (void)setWs_originX:(CGFloat)ws_originX {
    CGRect frame = self.frame;
    frame.origin.x = ws_originX;
    self.frame = frame;
}
- (CGFloat)ws_originX {
    return self.frame.origin.x;
}
- (void)setWs_originY:(CGFloat)ws_originY {
    CGRect frame = self.frame;
    frame.origin.y = ws_originY;
    self.frame = frame;
}
- (CGFloat)ws_originY {
    return self.frame.origin.y;
}
- (void)setWs_width:(CGFloat)ws_width {
    CGRect frame = self.frame;
    frame.size.width = ws_width;
    self.frame = frame;
}
- (CGFloat)ws_width {
    return self.frame.size.width;
}
- (void)setWs_height:(CGFloat)ws_height {
    CGRect frame = self.frame;
    frame.size.height = ws_height;
    self.frame = frame;
}
- (CGFloat)ws_height {
    return self.frame.size.height;
}
- (void)setWs_origin:(CGPoint)ws_origin {
    CGRect frame = self.frame;
    frame.origin = ws_origin;
    self.frame = frame;
}
- (CGPoint)ws_origin {
    return self.frame.origin;
}
- (void)setWs_size:(CGSize)ws_size {
    CGRect frame = self.frame;
    frame.size = ws_size;
    self.frame = frame;
}
- (CGSize)ws_size {
    return self.frame.size;
}
@end

static BOOL canRespondsAdjustedContentInset;
@implementation UIScrollView (WSLayout)
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        canRespondsAdjustedContentInset = [self instancesRespondToSelector:@selector(adjustedContentInset)];
    });
}
- (UIEdgeInsets)ws_inset {
    if (@available(iOS 11.0, *)) {
        if (canRespondsAdjustedContentInset) {
            return self.adjustedContentInset;
        }
    }
    return self.contentInset;
}
- (void)setWs_insetTop:(CGFloat)ws_insetTop {
    UIEdgeInsets inset = self.contentInset;
    inset.top = ws_insetTop;
    if (@available(iOS 11.0, *)) {
        if (canRespondsAdjustedContentInset) {
            inset.top -= (self.adjustedContentInset.top - self.contentInset.top);
        }
    }
    self.contentInset = inset;
}
- (CGFloat)ws_insetTop {
    return self.ws_inset.top;
}
- (void)setWs_insetBottom:(CGFloat)ws_insetBottom {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = ws_insetBottom;
    if (@available(iOS 11.0, *)) {
        if (canRespondsAdjustedContentInset) {
            inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom);
        }
    }
    self.contentInset = inset;
}
- (CGFloat)ws_insetBottom {
    return self.ws_inset.bottom;
}
- (void)setWs_insetLeft:(CGFloat)ws_insetLeft {
    UIEdgeInsets inset = self.contentInset;
    inset.left = ws_insetLeft;
    if (@available(iOS 11.0, *)) {
        if (canRespondsAdjustedContentInset) {
            inset.left -= (self.adjustedContentInset.left - self.contentInset.left);
        }
    }
    self.contentInset = inset;
}
- (CGFloat)ws_insetLeft {
    return self.ws_inset.left;
}
- (void)setWs_insetRight:(CGFloat)ws_insetRight {
    UIEdgeInsets inset = self.contentInset;
    inset.right = ws_insetRight;
    if (@available(iOS 11.0, *)) {
        if (canRespondsAdjustedContentInset) {
            inset.right -= (self.adjustedContentInset.right - self.contentInset.right);
        }
    }
    self.contentInset = inset;
}
- (CGFloat)ws_insetRight {
    return self.ws_inset.right;
}
- (void)setWs_offsetX:(CGFloat)ws_offsetX {
    CGPoint offset = self.contentOffset;
    offset.x = ws_offsetX;
    self.contentOffset = offset;
}
- (CGFloat)ws_offsetX {
    return self.contentOffset.x;
}
- (void)setWs_offsetY:(CGFloat)ws_offsetY {
    CGPoint offset = self.contentOffset;
    offset.y = ws_offsetY;
    self.contentOffset = offset;
}
- (CGFloat)ws_offsetY {
    return self.contentOffset.y;
}
- (void)setWs_contentWidth:(CGFloat)ws_contentWidth {
    CGSize size = self.contentSize;
    size.width = ws_contentWidth;
    self.contentSize = size;
}
- (CGFloat)ws_contentWidth {
    return self.contentSize.width;
}
- (void)setWs_contentHeight:(CGFloat)ws_contentHeight {
    CGSize size = self.contentSize;
    size.height = ws_contentHeight;
    self.contentSize = size;
}
- (CGFloat)ws_contentHeight {
    return self.contentSize.height;
}
@end
