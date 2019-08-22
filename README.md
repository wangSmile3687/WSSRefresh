# WSSRefresh

[![CI Status](https://img.shields.io/travis/18566663687@163.com/WSSRefresh.svg?style=flat)](https://travis-ci.org/18566663687@163.com/WSSRefresh)
[![Version](https://img.shields.io/cocoapods/v/WSSRefresh.svg?style=flat)](https://cocoapods.org/pods/WSSRefresh)
[![License](https://img.shields.io/cocoapods/l/WSSRefresh.svg?style=flat)](https://cocoapods.org/pods/WSSRefresh)
[![Platform](https://img.shields.io/cocoapods/p/WSSRefresh.svg?style=flat)](https://cocoapods.org/pods/WSSRefresh)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

WSSRefresh is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WSSRefresh'
```

使用说明：

1.pod  'WSSRefresh/VerticalRefresh'  上下刷新 

2.pod 'WSSRefresh/HorizontalRefresh' 左右刷新

3.pod 'WSSRefresh/Base' 继承footerControl、headerControl实现自定义，可以参考'WSSRefresh/VerticalRefresh' 和'WSSRefresh/HorizontalRefresh'的实现方式

4.刷新方式
self.tableView.ws_refreshHeader = [WSSRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];

self.tableView.ws_refreshHeader = [WSSRefreshHeader headerWithRefreshingBlock:{
// do something
}];

WSRefreshHeader *header = [WSSRefreshHeader headerWithRefreshingBlock:{
//do something
}];
self.tableView.ws_refreshHeader = header;

5.刷新结束后需要文字提醒的调用方式 例如：
[strongSelf.collectionView.ws_refreshAutoFooter endRefreshingWithAlerText:@"嘿嘿嘿嘿嘿" withTextColor:[UIColor blueColor] CompletionBlock:{
// do something
}];


## Author

wangsi,18566663687@163.com

## License

WSSRefresh is available under the MIT license. See the LICENSE file for more info.
