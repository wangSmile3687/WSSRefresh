//
//  WSSRefreshHeader.h
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import "WSSRefreshHeaderControl.h"
typedef NSString *(^LastUpdatedTimeTextBlock)(NSDate *lastUpdatedTimeDate);
@interface WSSRefreshHeader : WSSRefreshHeaderControl
@property (nonatomic, strong, readonly) UILabel   *lastUpdatedTimeLab;
@property (nonatomic, strong, readonly) UILabel   *stateLab;
@property (nonatomic, copy) LastUpdatedTimeTextBlock lastUpdatedTimeTextBlock;
@property (nonatomic, assign) CGFloat   labLeftInset;
- (void)setTitle:(NSString *)title forState:(WSSRefreshState)state;
@end

