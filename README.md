# ZKTimerService

一种列表活动倒计时解决方案。Demo中已做封装，可直接使用。

## ScreenShot

![image](https://github.com/bestDew/ZKTimerServiceDemo/blob/master/ZKTimerServiceDemo/Untitled.gif)

## Features

-   全局共享同一个倒计时服务
-   通过 NTP 服务器获取网络时间，避免受本地时间不准或被恶意修改的影响
-   通过获取设备运行时长来对应用进入前后台做时间偏移处理

## API

```objc

/** 单例宏 */
#define TIMER_SERVICE_INSTANCE [ZKTimerService sharedService]

@class ZKTimerService;

@protocol ZKTimerListener <NSObject>

/** 计时器的代理方法，每秒回调一次 */
- (void)didOnTimer:(ZKTimerService *)service;

@end

@interface ZKTimerService : NSObject

/** 判断服务是否已开启 */
@property (nonatomic, readonly, assign) BOOL isStart;
/** 所有收听者 */
@property (nonatomic, readonly, copy) NSArray *allListeners;
/** 计时器累加的秒数 */
@property (nonatomic, readonly, assign) NSInteger timeInterval;

/**
 *  如果你需要共享服务，你可以使用此方法创建一个单例对象
 *  否则，应使用 -init 进行初始化
 */
+ (instancetype)sharedService;

/**
 *  开启时间同步
 *  开启后，将使用网络时间作为时间源，避免受本地时间有可能不准的影响
 *  建议在程序刚开始启动时开启
 */
+ (void)timeSynchronization;

/** 当前网络标准时间（需要先开启时间同步 [ZKTimerService timeSynchronization]）*/
+ (NSDate *)networkDate;

/** 开启服务 */
- (void)start;

/**
 *  取消服务
 *  如果服务中仍有收听者，则不会执行，并返回 NO
 */
- (BOOL)cancel;

/**
 *  强制取消服务
 *  注意：此方法会移除所有收听者，并将 timeInterval 重置为 0，除非你明确没有其他界面收听者【正在】使用计时服务，否则你不应该调用此方法，而是调用：-removeListener: 将其从收听者中移除
 */
- (void)invalidateAndCancel;

/** 将 timeInterval 重置为 0 */
- (void)resetTimeInterval;

/** 添加一个收听者，该收听者必须遵循 ZKTimerListener 协议 */
- (void)addListener:(id<ZKTimerListener>)listener;
/** 移除一个收听者 */
- (void)removeListener:(id<ZKTimerListener>)listener;
/** 移除所有收听者 */
- (void)removeAllListeners;

@end

```

## Usage

第一步：在App刚开始启动时启用网络时间同步：
```objc

[ZKTimerService timeSynchronization];

```

第二步：遵循协议并实现代理方法
```objc

<ZKTimerListener>

[[ZKTimerService sharedService] addListener:self];

- (void)didOnTimer:(ZKTimerService *)service {
    // TODO...
}

```
第三步：启动服务
```objc

[[ZKTimerService sharedService] start];

```

## Thanks

如果对你有帮助，赏颗星吧😘。
