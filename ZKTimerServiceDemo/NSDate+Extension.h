//
//  NSDate+Extension.h
//  ZKTimerServiceDemo
//
//  Created by bestdew on 2019/3/5.
//  Copyright © 2019 bestdew. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Extension)

@property (nonatomic, readonly, strong) NSDate *nextDate;
@property (nonatomic, readonly, copy) NSString *dateString;

@end

NS_ASSUME_NONNULL_END
