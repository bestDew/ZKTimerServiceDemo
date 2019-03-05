//
//  DiscoverViewController.m
//  ZKTimerServiceDemo
//
//  Created by bestdew on 2019/3/4.
//  Copyright © 2019 bestdew. All rights reserved.
//

#import "DiscoverViewController.h"
#import "SecondaryViewController.h"

static NSString *kCellReuseId = @"DiscoverActivityCell";

@interface DiscoverViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<ActivityModel *> *models;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTableView];
    [self mockRequestData];
    [TIMER_SERVICE_INSTANCE start];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tableView deselectRowIfNeededWithTransitionCoordinator:self.transitionCoordinator animated:animated];
}

- (void)addTableView
{
    [self.view addSubview:({
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ActivityCell class] forCellReuseIdentifier:kCellReuseId];
        _tableView;
    })];
}

- (void)mockRequestData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray<ActivityModel *> *mutArray = [NSMutableArray array];
        for (NSInteger i = 0; i < 30; i++) {
            ActivityModel *model = [[ActivityModel alloc] init];
            model.text = [@"Discover-" stringByAppendingString:@(i).stringValue];
            // 因为使用单例且服务已启动，这里计算时长时必须加上当前计时服务的时间偏移量
            model.timeInterval = (arc4random() % 5000) + TIMER_SERVICE_INSTANCE.timeInterval;
            [mutArray addObject:model];
        }
        _models = mutArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondaryViewController *vc = [[SecondaryViewController alloc] init];
    vc.model = _models[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseId forIndexPath:indexPath];
    cell.model = _models[indexPath.row];
    
    return cell;
}

@end
