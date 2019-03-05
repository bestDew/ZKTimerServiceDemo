//
//  ActivityCell.m
//  ZKTimerServiceDemo
//
//  Created by bestdew on 2019/3/5.
//  Copyright © 2019 bestdew. All rights reserved.
//

#import "ActivityCell.h"

@implementation ActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        
        [TIMER_SERVICE_INSTANCE addListener:self];
    }
    return self;
}

- (void)setModel:(ActivityModel *)model
{
    _model = model;
    
    self.textLabel.text = model.text;
    
    [self didOnTimer:TIMER_SERVICE_INSTANCE];
}

- (void)didOnTimer:(ZKTimerService *)service
{
    NSInteger leftTimeInterval = _model.timeInterval - service.timeInterval;
    if (leftTimeInterval <= 0) {
        self.detailTextLabel.text = @"活动结束";
    } else {
        NSInteger hours = leftTimeInterval / 3600;
        NSInteger minutes = leftTimeInterval / 60 % 60;
        NSInteger seconds = leftTimeInterval % 60;
        self.detailTextLabel.text = [NSString stringWithFormat:@"距离活动结束还有：%02zd:%02zd:%02zd", hours, minutes, seconds];
    }
}

- (void)dealloc
{
    [TIMER_SERVICE_INSTANCE removeListener:self];
}

@end
