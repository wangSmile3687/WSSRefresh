//
//  WSSRefreshAutoFooter.h
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import "WSSRefreshAutoFooterControl.h"

@interface WSSRefreshAutoFooter : WSSRefreshAutoFooterControl
@property (nonatomic, strong, readonly) UILabel   *stateLab;
@property (nonatomic, assign) CGFloat   labLeftInset;
- (void)setTitle:(NSString *)title forState:(WSSRefreshState)state;
@end

