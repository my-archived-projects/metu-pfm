//
//  BalanceSheetTablesDataSource.h
//  PFM
//
//  Created by Metehan Karabiber on 3/1/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

@interface BalanceSheetTablesDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSArray *curAssets, *fixedAssets, *shortLiabilities, *longLiabilities, *capitals;

- (instancetype) initWithActiveTable:(UITableView *)atv passiveTable:(UITableView *)ptv;

@end
