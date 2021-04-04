//
//  PopoverTableVC.h
//  PFM
//
//  Created by Metehan Karabiber on 3/22/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

@class TransactionVC;

#import "PopoverTableDelegate.h"

@interface PopoverTableVC : UITableViewController
@property (nonatomic) NSArray *array;
@property (nonatomic, weak) id<PopoverTableDelegate> delegate;
@property (nonatomic, weak) UIControl *popoverSource;

- (id) initWithArray:(NSArray *)array delegate:(id<PopoverTableDelegate>) delegate width:(CGFloat)w;

@end
