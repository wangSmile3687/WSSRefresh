//
//  WSSRefreshBackFooter.h
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import "WSSRefreshBackFooterControl.h"

@interface WSSRefreshBackFooter : WSSRefreshBackFooterControl
@property (nonatomic, strong, readonly) UILabel   *stateLab;
@property (nonatomic, assign) CGFloat   labLeftInset;
- (void)setTitle:(NSString *)title forState:(WSSRefreshState)state;
@end

