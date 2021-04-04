//
//  TransactionItemVC.m
//  PFM
//
//  Created by Metehan Karabiber on 01/04/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "TransactionItemVC.h"
#import "TransactionItem.h"
#import "Account.h"

@implementation TransactionItemVC

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TransactionItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	UILabel *nameLbl, *amountLbl;

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		
		nameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
		nameLbl.font = [UIFont systemFontOfSize:17];
		nameLbl.textColor = [UIColor blackColor];
		nameLbl.tag = 1001;
		[cell.contentView addSubview:nameLbl];

		amountLbl = [[UILabel alloc] initWithFrame:CGRectZero];
		amountLbl.font = [UIFont systemFontOfSize:17];
		amountLbl.textColor = [UIColor blackColor];
		amountLbl.textAlignment = NSTextAlignmentRight;
		amountLbl.tag = 1002;
		[cell.contentView addSubview:amountLbl];
	}
	else {
		nameLbl = (UILabel *)[cell.contentView viewWithTag:1001];
		amountLbl = (UILabel *)[cell.contentView viewWithTag:1002];
	}

    TransactionItem *tx = self.items[indexPath.row] ;
	nameLbl.frame = tx.isDebit.boolValue ? CGRectMake(16, 0, 200, 44) : CGRectMake(52, 0, 200, 44);
	amountLbl.frame = tx.isDebit.boolValue ? CGRectMake(220, 0, 120, 44) : CGRectMake(260, 0, 120, 44);

	nameLbl.text = tx.relAccount.name;
	amountLbl.text = [[Utils numberFormatter] stringFromNumber:tx.amount];

    return cell;
}

@end