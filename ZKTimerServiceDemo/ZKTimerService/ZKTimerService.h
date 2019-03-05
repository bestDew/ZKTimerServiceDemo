//
//  ZKTimerService.h
//  ZKTimerServiceDemo
//
//  Created by bestdew on 2019/3/4.
//  Copyright © 2019 bestdew. All rights reserved.
//
//                      d*##$.
// zP"""""$e.           $"    $o
//4$       '$          $"      $
//'$        '$        J$       $F
// 'b        $k       $>       $
//  $k        $r     J$       d$
//  '$         $     $"       $~
//   '$        "$   '$E       $
//    $         $L   $"      $F ...
//     $.       4B   $      $$$*"""*b
//     '$        $.  $$     $$      $F
//      "$       R$  $F     $"      $
//       $k      ?$ u*     dF      .$
//       ^$.      $$"     z$      u$$$$e
//        #$b             $E.dW@e$"    ?$
//         #$           .o$$# d$$$$c    ?F
//          $      .d$$#" . zo$>   #$r .uF
//          $L .u$*"      $&$$$k   .$$d$$F
//           $$"            ""^"$$$P"$P9$
//          JP              .o$$$$u:$P $$
//          $          ..ue$"      ""  $"
//         d$          $F              $
//         $$     ....udE             4B
//          #$    """"` $r            @$
//           ^$L        '$            $F
//             RN        4N           $
//              *$b                  d$
//               $$k                 $F
//               $$b                $F
//                 $""               $F
//                 '$                $
//                  $L               $
//                  '$               $
//                   $               $

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 单例宏 */
#define TIMER_SERVICE_INSTANCE [ZKTimerService sharedService]

@class ZKTimerService;

@protocol ZKTimerListener <NSObject>

@required
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

/** 当前网络标准时间 */
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

NS_ASSUME_NONNULL_END
