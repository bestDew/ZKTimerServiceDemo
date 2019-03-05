//
//  ActivityModel.h
//  ZKTimerServiceDemo
//
//  Created by bestdew on 2019/3/5.
//  Copyright © 2019 bestdew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger timeInterval;

+ (instancetype)modelWithText:(NSString *)text timeInterval:(NSInteger)timeInterval;

@end
