//
//  ActivityCell.h
//  ZKTimerServiceDemo
//
//  Created by bestdew on 2019/3/5.
//  Copyright © 2019 bestdew. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityCell : UITableViewCell <ZKTimerListener>

@property (nonatomic, strong) ActivityModel *model;

@end

NS_ASSUME_NONNULL_END
