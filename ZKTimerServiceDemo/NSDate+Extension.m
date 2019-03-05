//
//  NSDate+Extension.m
//  ZKTimerServiceDemo
//
//  Created by bestdew on 2019/3/5.
//  Copyright © 2019 bestdew. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSDate *)nextDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    [components setDay:([components day] + 1)];
    
    return [calendar dateFromComponents:components];
}

- (NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return [formatter stringFromDate:self];
}

@end
