//
//  WSSRefreshHeader.m
//  WSSRefresh
//
//  Created by smile on 2019/8/22.
//

#import "WSSRefreshHeader.h"
#import "WSSRefreshConst.h"
@interface WSSRefreshHeader ()
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong, readwrite) UILabel   *lastUpdatedTimeLab;
@property (nonatomic, strong, readwrite) UILabel   *stateLab;
@property (nonatomic, strong) NSMutableDictionary  *stateTitlesMutDict;
@end
@implementation WSSRefreshHeader

- (void)prepare {
    [super prepare];
    
    self.labLeftInset = WSSRefreshLabelLeftInset;
    [self setTitle:WSSRefreshHeaderNoneText forState:WSSRefreshStateNone];
    [self setTitle:WSSRefreshHeaderPullingText forState:WSSRefreshStatePulling];
    [self setTitle:WSSRefreshHeaderRefreshingText forState:WSSRefreshStateWillRefresh];
    [self setTitle:WSSRefreshHeaderRefreshingText forState:WSSRefreshStateRefreshing];
}
- (void)setupSubviews {
    [super setupSubviews];
    
    CGFloat arrowCenterX = self.ws_width * 0.5;
    CGFloat stateWidth = 0.0;
    CGFloat timeWidth = 0.0;
    if (!self.stateLab.hidden) {
        stateWidth = [self getTextWidth:self.stateLab.text withFont:self.stateLab.font];
    }
    if (!self.lastUpdatedTimeLab.hidden) {
        timeWidth = [self getTextWidth:self.lastUpdatedTimeLab.text withFont:self.lastUpdatedTimeLab.font];
    }
    CGFloat textWidth = MAX(stateWidth, timeWidth);
    if (textWidth > self.ws_width-20-self.labLeftInset) {
        textWidth = self.ws_width-20-self.labLeftInset;
    }
    if (textWidth != 0) {
        arrowCenterX -= textWidth / 2 + self.labLeftInset;
    }
    CGFloat arrowCenterY = self.ws_height * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    if (self.arrowImgView.constraints.count == 0) {
        self.arrowImgView.ws_size = self.arrowImgView.image.size;
        self.arrowImgView.center = arrowCenter;
    }
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = arrowCenter;
    }
    self.arrowImgView.tintColor = self.stateLab.textColor;
    
    if (stateWidth > 0 && timeWidth > 0) {
        [self setStateLabFrameWithTextWidth:textWidth withShowCenterY:NO];
        [self setLastUpdatedTimeLabFrameWithTextWidth:textWidth withShowCenterY:NO];
    } else {
        if (stateWidth > 0) {
            [self setStateLabFrameWithTextWidth:textWidth withShowCenterY:YES];
        }
        if (timeWidth > 0) {
            [self setLastUpdatedTimeLabFrameWithTextWidth:textWidth withShowCenterY:YES];
        }
    }
}
#pragma mark - public method
- (void)setTitle:(NSString *)title forState:(WSSRefreshState)state {
    if (title.length == 0) {
        return;
    }
    self.stateTitlesMutDict[@(state)] = title;
    self.stateLab.text = self.stateTitlesMutDict[@(state)];
}
- (void)refreshStateDidChange:(WSSRefreshState)state oldState:(WSSRefreshState)oldState {
    [super refreshStateDidChange:state oldState:oldState];
    self.stateLab.text = self.stateTitlesMutDict[@(state)];
    self.lastUpdatedTimeKey = self.lastUpdatedTimeKey;
    
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
            self.arrowImgView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    } else if (state == WSSRefreshStateRefreshing) {
        self.loadingView.alpha = 1.0;
        [self.loadingView startAnimating];
        self.arrowImgView.hidden = YES;
    }
}
#pragma mark - private method
- (void)setStateLabFrameWithTextWidth:(CGFloat)textWidth withShowCenterY:(BOOL)showCenterY {
    if (showCenterY) {
        self.stateLab.ws_originY = self.ws_height * 0.25;
    } else {
        self.stateLab.ws_originY = 0;
    }
    self.stateLab.ws_originX = (self.ws_width-textWidth)/2.0;
    self.stateLab.ws_width = textWidth;
    self.stateLab.ws_height = self.ws_height * 0.5;
}
- (void)setLastUpdatedTimeLabFrameWithTextWidth:(CGFloat)textWidth withShowCenterY:(BOOL)showCenterY {
    if (showCenterY) {
        self.lastUpdatedTimeLab.ws_originY = self.ws_height * 0.25;
    } else {
        self.lastUpdatedTimeLab.ws_originY = self.ws_height * 0.5;
    }
    self.lastUpdatedTimeLab.ws_originX = (self.ws_width-textWidth)/2.0;
    self.lastUpdatedTimeLab.ws_width = textWidth;
    self.lastUpdatedTimeLab.ws_height = self.ws_height * 0.5;
}
- (UIImage *)getImageWithImageName:(NSString *)imageName {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"VerticalRefresh" ofType:@"bundle"]];
    NSString *path = [bundle pathForResource:[NSString stringWithFormat:@"%@@%zdx",imageName,(NSInteger)[UIScreen mainScreen].scale] ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}
- (CGFloat)getTextWidth:(NSString *)text withFont:(UIFont *)font{
    CGFloat textWidth = 0.0;
    if (text.length > 0) {
        textWidth = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:@{NSFontAttributeName:font}
                                       context:nil].size.width;
    }
    return textWidth;
}
#pragma mark - setter
- (void)setLastUpdatedTimeKey:(NSString *)lastUpdatedTimeKey{
    [super setLastUpdatedTimeKey:lastUpdatedTimeKey];
    if (self.lastUpdatedTimeLab.hidden) return;
    NSDate *lastUpdatedTime = [[NSUserDefaults standardUserDefaults] objectForKey:lastUpdatedTimeKey];
    if (self.lastUpdatedTimeTextBlock) {
        self.lastUpdatedTimeLab.text = self.lastUpdatedTimeTextBlock(lastUpdatedTime);
        return;
    }
    if (lastUpdatedTime) {
        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdatedTime];
        NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        BOOL isToday = NO;
        if ([cmp1 day] == [cmp2 day]) {
            formatter.dateFormat = @" HH:mm";
            isToday = YES;
        } else if ([cmp1 year] == [cmp2 year]) {
            formatter.dateFormat = @"MM-dd HH:mm";
        } else {
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        }
        NSString *time = [formatter stringFromDate:lastUpdatedTime];
        self.lastUpdatedTimeLab.text = [NSString stringWithFormat:@"最后更新：%@%@",isToday ? @"今天" : @"",time];
    } else {
        self.lastUpdatedTimeLab.text = @"最后更新：无记录";
    }
}
#pragma mark - getter
- (UILabel *)lastUpdatedTimeLab {
    if (!_lastUpdatedTimeLab) {
        _lastUpdatedTimeLab = [[UILabel alloc] init];
        _lastUpdatedTimeLab.font = [UIFont boldSystemFontOfSize:14];
        _lastUpdatedTimeLab.textColor = WSSUIColorFromRGB(0x5A5A5A);
        _lastUpdatedTimeLab.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _lastUpdatedTimeLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lastUpdatedTimeLab];
    }
    return _lastUpdatedTimeLab;
}
- (UILabel *)stateLab {
    if (!_stateLab) {
        _stateLab = [[UILabel alloc] init];
        _stateLab.font = [UIFont boldSystemFontOfSize:14];
        _stateLab.textColor = WSSUIColorFromRGB(0x5A5A5A);
        _stateLab.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _stateLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_stateLab];
    }
    return _stateLab;
}
- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] initWithImage:[self getImageWithImageName:@"arrow"]];
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
- (NSMutableDictionary *)stateTitlesMutDict {
    if (!_stateTitlesMutDict) {
        _stateTitlesMutDict = [NSMutableDictionary new];
    }
    return _stateTitlesMutDict;
}

@end
