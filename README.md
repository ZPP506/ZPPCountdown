## Requirements
**实现按钮倒计时: 基于GCD的倒计时**

[github链接:https://github.com/ZPP506/ZPPCountdown](https://github.com/ZPP506/ZPPCountdown)

####使用NSTimer实现倒计时缺点:
>1. NSTimer加在main runloop中，模式是NSDefaultRunLoopMode，main负责所有主线程事件，例如UI界面的操作，复杂的运算，这样在同一个runloop中timer就会产生阻塞
>2. 模式的改变。主线程的 RunLoop 里有两个预置的 Mode：kCFRunLoopDefaultMode 和 UITrackingRunLoopMode



####GCD定时器不受RunLoop约束，比NSTimer更加准时

### 效果图
![381492d8-cccc-4b62-bfda-c06c6ffedbe8.gif](https://upload-images.jianshu.io/upload_images/11285123-d175545093ae95b8.gif?imageMogr2/auto-orient/strip)


## 使用方法
### 注意
1. Button:创建时候的类型不同闪烁效果不一样
 
> **UIButtonTypeCustom->普通**
> **UIButtonTypeSystem ->闪烁**
 
####开始倒计时
```
1:
[button startTimer:60]

2:
[button  startTimer:60 endComplete:nil];     
      
```

#### 取消倒计时
```
[button cancelTime]
```


## Installation

ZPPCountdown is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZPPCountdown'
```

## Author

张朋朋, 944160330@qq.com

## License

ZPPCountdown is available under the MIT license. See the LICENSE file for more info.
