//
//  TransactionQueryVC.m
//  PFM
//
//  Created by Metehan Karabiber on 28/03/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "TransactionQueryVC.h"
#import "TransactionItemVC.h"
#import "TQTableViewCell.h"
#import "TxUtils.h"
#import "Transaction.h"
#import "TransactionItem.h"

@interface TransactionQueryVC ()
@property (nonatomic) NSArray *transactions;
@property (nonatomic) UIPopoverController *txItemPopover;
@end

@implementation TransactionQueryVC

- (void) viewDidLoad {
    [super viewDidLoad];

	self.noTxLbl.hidden = YES;
	self.tableView.hidden = YES;
	[self.keyword becomeFirstResponder];
}

- (IBAction) query:(id)sender {
	[self.keyword resignFirstResponder];
	self.txItemPopover = nil;
	
	self.transactions = [TxUtils fetchTransactionsWithPredicate:
						 [NSPredicate predicateWithFormat:@"desc CONTAINS[cd] %@",
						  [Utils trim:self.keyword.text]]];

	self.tableView.hidden = (self.transactions.count == 0);
	self.noTxLbl.hidden = (self.transactions.count > 0);
	[self.tableView reloadData];
}

- (IBAction) close:(id)sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 48;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = [[UIView alloc] initWithFrame:[self.tableView headerViewForSection:section].frame];
	view.backgroundColor = [UIColor whiteColor];
	
	UILabel *referenceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 56, 44)];
	referenceLbl.text = @"REF #";
	referenceLbl.textAlignment = NSTextAlignmentCenter;
	referenceLbl.font = [UIFont boldSystemFontOfSize:16];
	referenceLbl.textColor = [UIColor blackColor];
	[view addSubview:referenceLbl];
	
	UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(56, 0, 82, 44)];
	dateLbl.text = @"TARİH";
	dateLbl.textAlignment = NSTextAlignmentCenter;
	dateLbl.font = [UIFont boldSystemFontOfSize:16];
	dateLbl.textColor = [UIColor blackColor];
	[view addSubview:dateLbl];
	
	UILabel *amountLbl = [[UILabel alloc] initWithFrame:CGRectMake(138, 0, 100, 44)];
	amountLbl.text = @"TUTAR";
	amountLbl.textAlignment = NSTextAlignmentCenter;
	amountLbl.font = [UIFont boldSystemFontOfSize:16];
	amountLbl.textColor = [UIColor blackColor];
	[view addSubview:amountLbl];
	
	
	UILabel *descLbl = [[UILabel alloc] initWithFrame:CGRectMake(248, 0, 200, 44)];
	descLbl.text = @"AÇIKLAMA";
	descLbl.textAlignment = NSTextAlignmentLeft;
	descLbl.font = [UIFont boldSystemFontOfSize:16];
	descLbl.textColor = [UIColor blackColor];
	[view addSubview:descLbl];
	
	UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 46, 482, 2)];
	bottomBorder.backgroundColor = [UIColor blackColor];
	[view addSubview:bottomBorder];
	[view bringSubviewToFront:bottomBorder];
	
	return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.transactions.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"StatementCell";
	TQTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil) {
		cell = [[TQTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
	Transaction *tx = self.transactions[indexPath.row];
	cell.referenceLbl.text = [NSString stringWithFormat:@"%d", tx.tid.intValue];
	cell.dateLbl.text = [Utils getStringFrom:tx.date];
	cell.descLbl.text = tx.desc;

	double sum = ((NSNumber *)[tx.relItems valueForKeyPath:@"@sum.amount"]).doubleValue;
	cell.amountLbl.text = [[Utils numberFormatter] stringFromNumber:@(sum/2)];
	
	return cell;
}

- (void) tableView: (UITableView *) tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *) indexPath {

    Transaction *tx = self.transactions[indexPath.row];

    if (self.txItemPopover && self.txItemPopover.isPopoverVisible) {
        [self.txItemPopover dismissPopoverAnimated:YES];
        self.txItemPopover = nil;
    }
    else {
		TransactionItemVC *popoverTable = [[TransactionItemVC alloc] init];
		NSArray *allItems = [tx.relItems allObjects];

		NSMutableArray *items = [[NSMutableArray alloc] init];
		for (TransactionItem *item in allItems) {
			if (item.isDebit.boolValue) {
				[items addObject:item];
			}
		}
		for (TransactionItem *item in allItems) {
			if (!item.isDebit.boolValue) {
				[items addObject:item];
			}
		}
		popoverTable.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		popoverTable.items = items;
		popoverTable.preferredContentSize = CGSizeMake(400, items.count * 44);
		self.txItemPopover = [[UIPopoverController alloc] initWithContentViewController:popoverTable];

        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        [self.txItemPopover presentPopoverFromRect:CGRectMake(450, 22, 1, 1)
                                            inView:cell.contentView
                          permittedArrowDirections:UIPopoverArrowDirectionRight
                                          animated:YES];

        self.txItemPopover.passthroughViews = nil;
    }
}

@end
