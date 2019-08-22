//
//  VViewController.m
//  WSRefresh_Example
//
//  Created by smile on 2019/8/14.
//  Copyright © 2019 wangSmile. All rights reserved.
//

#import "VViewController.h"
#import <WSSRefresh/WSSVerticalRefresh.h>
@interface VCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *lab;
@property (nonatomic, copy) NSString *title;
@end

@implementation VCollectionViewCell

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
@interface VViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, strong)   UICollectionView *collectionView;
@property (nonatomic, assign)   NSInteger refreshFooterCount;
@end

@implementation VViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor cyanColor];
    btn.frame = CGRectMake(20, 20, 50, 44);
    [btn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    
//    WSRefreshHeader *header = [WSSRefreshHeader headerWithRefreshingBlock:^{
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            [strongSelf.tableView.ws_refreshHeader endRefreshingWithAlerText:@"哈哈哈哈哈" withTextColor:[UIColor blueColor] CompletionBlock:^{
//                [strongSelf.tableView reloadData];
//            }];
//
//        });
//
//    }];
//    header.stateLab.hidden = YES;
//    header.lastUpdatedTimeLab.hidden = YES;
//    self.tableView.ws_refreshHeader = header;
    
    self.tableView.ws_refreshHeader = [WSSRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    
    self.tableView.ws_refreshHeader.backgroundColor = [UIColor cyanColor];
    [self.tableView.ws_refreshHeader beginRefreshing];
    
//
//    self.tableView.ws_refreshAutoFooter = [WSSRefreshAutoFooter footerWithRefreshingBlock:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            [strongSelf.tableView.ws_refreshAutoFooter endRefreshingWithAlerText:@"嘿嘿嘿嘿嘿" withTextColor:[UIColor blueColor] CompletionBlock:^{
//                ++ strongSelf.refreshFooterCount ;
//                [strongSelf.tableView reloadData];
//            }];
//        });
//    }];
    
    

    
    
    
    self.tableView.ws_refreshBackFooter = [WSSRefreshBackFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.tableView.ws_refreshBackFooter endRefreshingWithAlerText:@"嘿嘿嘿嘿嘿" withTextColor:[UIColor blueColor] CompletionBlock:^{
                ++ strongSelf.refreshFooterCount ;
                [strongSelf.tableView reloadData];
            }];
        });
    }];

    
    
//    [self.view addSubview:self.collectionView];
//
//        __weak typeof(self) weakSelf = self;
//    self.collectionView.ws_refreshHeader = [WSSRefreshHeader headerWithRefreshingBlock:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            [strongSelf.collectionView.ws_refreshHeader endRefreshingWithAlerText:@"哈哈哈哈哈" withTextColor:[UIColor blueColor] CompletionBlock:^{
//                [strongSelf.collectionView reloadData];
//            }];
//
//        });
//    }];
//    self.collectionView.ws_refreshAutoFooter = [WSSRefreshAutoFooter footerWithRefreshingBlock:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            [strongSelf.collectionView.ws_refreshAutoFooter endRefreshingWithAlerText:@"嘿嘿嘿嘿嘿" withTextColor:[UIColor blueColor] CompletionBlock:^{
//                ++ strongSelf.refreshFooterCount ;
//                NSLog(@"-----refreshFooterCount----  %ld",(long)strongSelf.refreshFooterCount);
//                if (strongSelf.refreshFooterCount == 3) {
////                    [strongSelf.collectionView.ws_refreshAutoFooter endRefreshingWithNoMoreData];
////                    [strongSelf.collectionView.ws_refreshAutoFooter setHidden:YES];
//                }
//                [strongSelf.collectionView reloadData];
//            }];
//        });
//    }];
    
//    self.collectionView.ws_refreshBackFooter = [WSSRefreshBackFooter footerWithRefreshingBlock:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            [strongSelf.collectionView.ws_refreshBackFooter endRefreshingWithAlerText:@"嘿嘿嘿嘿嘿" withTextColor:[UIColor blueColor] CompletionBlock:^{
//                ++ strongSelf.refreshFooterCount ;
//                [strongSelf.collectionView reloadData];
//            }];
//        });
//    }];
    
//    [self.collectionView.ws_refreshHeader beginRefreshing];
    
    

}
- (void)getData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                __weak typeof(self) weakSelf = self;
            [weakSelf.tableView.ws_refreshHeader endRefreshingWithAlerText:@"哈哈哈哈哈" withTextColor:[UIColor blueColor] CompletionBlock:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf.tableView reloadData];
            }];

        });
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.refreshFooterCount > 0) {
        if (self.refreshFooterCount >= 2) {
            self.refreshFooterCount = 2;
        }
        return 20 * (self.refreshFooterCount + 1);
    }
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    cell.textLabel.textColor = [UIColor redColor];
    return cell;
}
#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.refreshFooterCount > 0) {
        if (self.refreshFooterCount >= 2) {
            self.refreshFooterCount = 2;
        }
        return 10 * (self.refreshFooterCount + 1);
    }
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VCollectionViewCell" forIndexPath:indexPath];
    cell.title = [NSString stringWithFormat:@"滴滴滴%ld",(long)indexPath.row];
    return cell;
}
#pragma mark -
- (void)backBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(150, 200);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-100) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor cyanColor];
        [_collectionView registerClass:[VCollectionViewCell class] forCellWithReuseIdentifier:@"VCollectionViewCell"];
    }
    return _collectionView;
}

@end
