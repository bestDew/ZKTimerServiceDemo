//
//  SecondaryViewController.m
//  ZKTimerServiceDemo
//
//  Created by bestdew on 2019/3/4.
//  Copyright © 2019 bestdew. All rights reserved.
//

#import "SecondaryViewController.h"
#import "ActivityModel.h"

@interface SecondaryViewController () <ZKTimerListener>

@property (nonatomic, strong) UILabel *label;

@end

@implementation SecondaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _model.text;
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.bounds.size.width, 100.f)];
    _label.center = self.view.center;
    _label.numberOfLines = 0;
    _label.font = [UIFont boldSystemFontOfSize:28.f];
    _label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_label];
    
    [TIMER_SERVICE_INSTANCE addListener:self];
    [self didOnTimer:TIMER_SERVICE_INSTANCE];
}

- (void)didOnTimer:(ZKTimerService *)service
{
    NSInteger leftTimeInterval = _model.timeInterval - service.timeInterval;
    if (leftTimeInterval <= 0) {
        _label.text = @"活动结束";
    } else {
        NSInteger hours = leftTimeInterval / 3600;
        NSInteger minutes = leftTimeInterval / 60 % 60;
        NSInteger seconds = leftTimeInterval % 60;
        _label.text = [NSString stringWithFormat:@"距离活动结束还有\n%02zd:%02zd:%02zd", hours, minutes, seconds];
    }
}

- (void)dealloc
{
    [TIMER_SERVICE_INSTANCE removeListener:self];
}

@end
