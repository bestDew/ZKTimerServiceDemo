//
//  UITableView+Extension.m
//  ZKTimerServiceDemo
//
//  Created by bestdew on 2019/3/5.
//  Copyright © 2019 bestdew. All rights reserved.
//

#import "UITableView+Extension.h"

@implementation UITableView (Extension)

- (void)deselectRowIfNeededWithTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator animated:(BOOL)animated
{
    if (!self.indexPathForSelectedRow) return;
    if (!coordinator) {
        [self deselectRowAtIndexPath:self.indexPathForSelectedRow animated:animated];
    }
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self deselectRowAtIndexPath:self.indexPathForSelectedRow animated:animated];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (context.isCancelled) {
            [self selectRowAtIndexPath:self.indexPathForSelectedRow animated:animated scrollPosition:UITableViewScrollPositionNone];
        }
    }];
}

@end
