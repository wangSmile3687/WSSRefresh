//
//  HViewController.m
//  WSRefresh_Example
//
//  Created by smile on 2019/8/14.
//  Copyright © 2019 wangSmile. All rights reserved.
//

#import "HViewController.h"
#import <WSSRefresh/WSSHorizontalRefresh.h>

@interface HCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *lab;
@property (nonatomic, copy) NSString *title;
@end

@implementation HCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.lab];
    }
    return self;
}
- (void)setTitle:(NSString *)title {
    _title = title;
    
    _lab.text = title;
    
}
#pragma mark - getter
- (UILabel *)lab {
    if (!_lab) {
        _lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 300)];
        _lab.font = [UIFont boldSystemFontOfSize:15];
        _lab.textColor = [UIColor redColor];
        _lab.textAlignment = NSTextAlignmentCenter;
    }
    return _lab;
}
@end


@interface HViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger refreshFooterCount;
@end

@implementation HViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor cyanColor];
    btn.frame = CGRectMake(20, 20, 50, 44);
    [btn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self.view addSubview:self.collectionView];
    __weak typeof(self) weakSelf = self;

    self.collectionView.ws_refreshHeader = [WSSRefreshHorizontalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.collectionView.ws_refreshHeader endRefreshingWithAlerText:@"哈\n哈\n哈\n哈\n哈" withTextColor:[UIColor blueColor] CompletionBlock:nil];
            [strongSelf.collectionView reloadData];
        });
    }];
    [self.collectionView.ws_refreshHeader beginRefreshing];
    
    
//    self.collectionView.ws_refreshAutoFooter = [WSSRefreshHorizontalAutoFooter footerWithRefreshingBlock:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            [strongSelf.collectionView.ws_refreshAutoFooter endRefreshingWithAlerText:@"嘿\n嘿\n嘿\n嘿\n嘿" withTextColor:[UIColor blueColor] CompletionBlock:^{
//                ++strongSelf.refreshFooterCount;
//                [strongSelf.collectionView reloadData];
//            }];
//        });
//    }];
//
    
    
    self.collectionView.ws_refreshBackFooter = [WSSRefreshHorizontalBackFooter footerWithRefreshingBlock:^{
        NSLog(@"------collectionView--------eeeeeeee-----------");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"------collectionView--------ffffff-----------");
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.collectionView.ws_refreshBackFooter endRefreshingWithAlerText:@"嘿\n嘿\n嘿\n嘿\n嘿" withTextColor:[UIColor blueColor] CompletionBlock:^{
                ++strongSelf.refreshFooterCount;
                [strongSelf.collectionView reloadData];
            }];
        });
    }];
    self.collectionView.ws_refreshBackFooter.backgroundColor = [UIColor redColor];
}
#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.refreshFooterCount > 0) {
        return 10 * (self.refreshFooterCount + 1);
    }
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HCollectionViewCell" forIndexPath:indexPath];
    cell.title = [NSString stringWithFormat:@"滴滴滴%ld",(long)indexPath.row];
    return cell;
}
#pragma mark -
- (void)backBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(100, 300);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 300) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor cyanColor];
        [_collectionView registerClass:[HCollectionViewCell class] forCellWithReuseIdentifier:@"HCollectionViewCell"];
    }
    return _collectionView;
}

@end
