//
//  ZKTimerService.m
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

#import "ZKTimerService.h"
#import "ios-ntp.h"
#import <sys/sysctl.h>

@import UIKit;

#define TIMER_SERVICE_LOCK()   dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER)
#define TIMER_SERVICE_UNLOCK() dispatch_semaphore_signal(self->_lock)

@interface ZKTimerService ()
{
    dispatch_semaphore_t _lock;
}
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSHashTable *map;
@property (nonatomic, assign) BOOL backgroudRecord;
@property (nonatomic, assign) NSTimeInterval lastUptime;

@end

@implementation ZKTimerService

+ (instancetype)sharedService
{
    static ZKTimerService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[ZKTimerService alloc] init];
    });
    return service;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        _lock = dispatch_semaphore_create(1);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

+ (void)timeSynchronization
{
    [NetworkClock sharedNetworkClock];
}

+ (NSDate *)networkDate
{
    return [NSDate threadsafeNetworkDate];
}

// 获取当前设备运行时长，不受系统时间影响
- (NSTimeInterval)getuptime
{
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    
    struct timeval now;
    struct timezone tz;
    gettimeofday(&now, &tz);
    
    double uptime = -1;
    
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0)
    {
        uptime = now.tv_sec - boottime.tv_sec;
        uptime += (double)(now.tv_usec - boottime.tv_usec) / 1000000.0;
    }
    return uptime;
}

- (void)start
{
    if (_isStart) return;
    
    _isStart = YES;
    [self timer];
}

- (BOOL)cancel
{
    if (_map.count > 0) return NO;
    
    _isStart = NO;
    [self removeTimer];
    return YES;
}

- (void)invalidateAndCancel
{
    _isStart = NO;
    [self removeTimer];
    [self resetTimeInterval];
    [self removeAllListeners];
}

- (void)resetTimeInterval
{
    _timeInterval = 0;
}

- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)onTimer
{
    [self timerActionWithTimeInterval:1];
}

- (void)timerActionWithTimeInterval:(NSInteger)timeInterval
{
    _timeInterval += timeInterval;
    [self.map.allObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id<ZKTimerListener> listener = obj;
        if ([listener respondsToSelector:@selector(didOnTimer:)]) {
            [listener didOnTimer:self];
        }
    }];
}

- (void)didEnterBackground:(NSNotification *)noti
{
    _backgroudRecord = (_timer != nil);
    if (_backgroudRecord) {
        _isStart = NO;
        _lastUptime = [self getuptime];
        [self removeTimer];
    }
}

- (void)willEnterForeground:(NSNotification *)noti
{
    if (_backgroudRecord) {
        NSTimeInterval timeInterval = [self getuptime] - _lastUptime;
        [self timerActionWithTimeInterval:timeInterval];
        [self start];
    }
}

- (void)addListener:(id<ZKTimerListener>)listener
{
    TIMER_SERVICE_LOCK();
    if (![self.map containsObject:listener]) {
        [self.map addObject:listener];
    }
    TIMER_SERVICE_UNLOCK();
}

- (void)removeListener:(id<ZKTimerListener>)listener
{
    TIMER_SERVICE_LOCK();
    if ([self.map containsObject:listener]) {
        [self.map removeObject:listener];
    }
    TIMER_SERVICE_UNLOCK();
}

- (void)removeAllListeners
{
    [self.map removeAllObjects];
}

- (NSArray *)allListeners
{
    return _map.allObjects;
}

- (NSHashTable *)map
{
    if (_map == nil) {
        
        _map = [NSHashTable weakObjectsHashTable];
    }
    return _map;
}

- (NSTimer *)timer
{
    if (_timer == nil) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
