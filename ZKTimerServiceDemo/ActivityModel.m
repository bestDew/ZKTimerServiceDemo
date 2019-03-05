//
//  ActivityModel.m
//  ZKTimerServiceDemo
//
//  Created by bestdew on 2019/3/5.
//  Copyright © 2019 bestdew. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel

+ (instancetype)modelWithText:(NSString *)text timeInterval:(NSInteger)timeInterval
{
    ActivityModel *model = [[ActivityModel alloc] init];
    model.text = text;
    model.timeInterval = timeInterval;
    
    return model;
}

@end
