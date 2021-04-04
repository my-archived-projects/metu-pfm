//
//  MonthlyReportVC.m
//  PFM
//
//  Created by Metehan Karabiber on 28/03/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "MonthlyReportVC.h"
#import "MonthlyReportCell.h"

#import "AccountUtils.h"
#import "TxUtils.h"
#import "Account.h"
#import "Transaction.h"
#import "TransactionItem.h"

@interface MonthlyReportVC () {
	int month[3];
	int year[3];
}
@property (nonatomic) NSArray *incomeAccounts, *expenseAccounts;
@property (nonatomic) NSMutableDictionary *incomeTotals, *expenseTotals;
@end

@implementation MonthlyReportVC

- (void) viewDidLoad {
	[super viewDidLoad];

	NSArray *dateArray = [[Utils getStringFrom:[NSDate date]] componentsSeparatedByString:@"."];
	month[0] = ((NSString *)dateArray[1]).intValue;
	year[0] = ((NSString *)dateArray[2]).intValue;

	month[1] = (month[0] == 1) ? 12 : month[0] - 1;
	year[1] = (month[0] == 1) ? year[0] - 1: year[0];

	month[2] = (month[1] == 1) ? 12 : month[1] - 1;
	year[2] = (month[1] == 1) ? year[1] - 1: year[1];

	self.incomeAccounts = [AccountUtils fetchAccountsWithPredicate:
						   [NSPredicate predicateWithFormat:@"subtype = %@", @(AccountSubtypeIncome)]];
	self.expenseAccounts = [AccountUtils fetchAccountsWithPredicate:
							[NSPredicate predicateWithFormat:@"subtype = %@", @(AccountSubtypeExpense)]];

    self.incomeTotals = [NSMutableDictionary dictionary];
    self.expenseTotals = [NSMutableDictionary dictionary];

    for (int i = 0; i < 3; i++) {
        NSDate *startDate = [Utils getDateFrom:[NSString stringWithFormat:@"01.%d.%d", month[i], year[i]]];
        NSDate *endDate = [Utils getDateFrom:[NSString stringWithFormat:@"%ld.%d.%d", [Utils getNumberOfDays:startDate], month[i], year[i]]];

        for (int j = 0; j< self.incomeAccounts.count; j++) {
            Account *account = self.incomeAccounts[j];

			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relAccount = %@ AND invrelItems.date >= %@ AND invrelItems.date <= %@",
                                      account, startDate, endDate];
			
			NSArray *txItems = [TxUtils fetchTransactionItemsWithPredicate:predicate];
			double sum = 0;
			for (TransactionItem *item in txItems) {
				if (!item.isDebit.boolValue) {
					sum += item.amount.doubleValue;
				}
				else {
					sum -= item.amount.doubleValue;
				}
			}
            NSMutableArray *newArray = self.incomeTotals[account.name] ? [self.incomeTotals[account.name] mutableCopy] : [NSMutableArray array];
            newArray[i] = [NSNumber numberWithDouble:sum];
            self.incomeTotals[account.name] = newArray;
		}

        for (int j = 0; j< self.expenseAccounts.count; j++) {
            Account *account = self.expenseAccounts[j];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relAccount = %@ AND invrelItems.date >= %@ AND invrelItems.date <= %@",
                                      account, startDate, endDate];
            
            NSArray *txItems = [TxUtils fetchTransactionItemsWithPredicate:predicate];
            double sum = 0;
            for (TransactionItem *item in txItems) {
                if (item.isDebit.boolValue) {
                    sum += item.amount.doubleValue;
                }
                else {
                    sum -= item.amount.doubleValue;
                }
            }
            NSMutableArray *newArray = self.expenseTotals[account.name] ? [self.expenseTotals[account.name] mutableCopy] : [NSMutableArray array];
            newArray[i] = [NSNumber numberWithDouble:sum];
            self.expenseTotals[account.name] = newArray;
        }
    }

    [self.tableView reloadData];
}

- (IBAction) close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (section == 0) ? self.incomeAccounts.count : self.expenseAccounts.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 48;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 752, 48)];
    view.backgroundColor = [UIColor whiteColor];

	UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 350, 48)];
	nameLbl.font = [UIFont boldSystemFontOfSize:20];
    nameLbl.text = (section == 0) ? @"GELİR HESAPLARI" : @"GİDER HESAPLARI";
    nameLbl.textColor = [UIColor colorWithRed:0 green:0.71 blue:0.98 alpha:1];
    [view addSubview:nameLbl];

	UILabel *month1Lbl = [[UILabel alloc] initWithFrame:CGRectMake(374, 0, 120, 48)];
	month1Lbl.font = [UIFont boldSystemFontOfSize:20];
    month1Lbl.text = months[month[0]-1];
    month1Lbl.textAlignment = NSTextAlignmentCenter;
    month1Lbl.textColor = [UIColor colorWithRed:0 green:0.71 blue:0.98 alpha:1];
    [view addSubview:month1Lbl];

	UILabel *month2Lbl = [[UILabel alloc] initWithFrame:CGRectMake(502, 0, 120, 48)];
	month2Lbl.font = [UIFont boldSystemFontOfSize:20];
    month2Lbl.text = months[month[1]-1];
    month2Lbl.textAlignment = NSTextAlignmentCenter;
    month2Lbl.textColor = [UIColor colorWithRed:0 green:0.71 blue:0.98 alpha:1];
    [view addSubview:month2Lbl];

	UILabel *month3Lbl = [[UILabel alloc] initWithFrame:CGRectMake(630, 0, 120, 48)];
	month3Lbl.font = [UIFont boldSystemFontOfSize:20];
    month3Lbl.text = months[month[2]-1];
    month3Lbl.textAlignment = NSTextAlignmentCenter;
    month3Lbl.textColor = [UIColor colorWithRed:0 green:0.71 blue:0.98 alpha:1];
    [view addSubview:month3Lbl];
    
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 46, 752, 2)];
    bottomBorder.backgroundColor = [UIColor blackColor];
    [view addSubview:bottomBorder];
    [view bringSubviewToFront:bottomBorder];

	return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 48;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 752, 48)];

    UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 752, 1)];
    topBorder.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:topBorder];
    [view bringSubviewToFront:topBorder];
    
    NSDictionary *accountTotals =  (section == 0) ? self.incomeTotals : self.expenseTotals;
    double month1, month2, month3;

    for (NSString *name in accountTotals) {
        NSArray *subTotals = accountTotals[name];

        month1 += ((NSNumber *)subTotals[0]).doubleValue;
        month2 += ((NSNumber *)subTotals[1]).doubleValue;
        month3 += ((NSNumber *)subTotals[2]).doubleValue;
    }

    UILabel *month1Lbl = [[UILabel alloc] initWithFrame:CGRectMake(374, 0, 120, 48)];
    month1Lbl.font = [UIFont boldSystemFontOfSize:17];
    month1Lbl.text = [[Utils numberFormatter] stringFromNumber:@(month1)];
    month1Lbl.textAlignment = NSTextAlignmentRight;
    [view addSubview:month1Lbl];

    UILabel *month2Lbl = [[UILabel alloc] initWithFrame:CGRectMake(502, 0, 120, 48)];
    month2Lbl.font = [UIFont boldSystemFontOfSize:17];
    month2Lbl.text = [[Utils numberFormatter] stringFromNumber:@(month2)];
    month2Lbl.textAlignment = NSTextAlignmentRight;
    [view addSubview:month2Lbl];

    UILabel *month3Lbl = [[UILabel alloc] initWithFrame:CGRectMake(630, 0, 120, 48)];
    month3Lbl.font = [UIFont boldSystemFontOfSize:17];
    month3Lbl.text = [[Utils numberFormatter] stringFromNumber:@(month3)];
    month3Lbl.textAlignment = NSTextAlignmentRight;
    [view addSubview:month3Lbl];
    
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"MonthlyReportCell";
	MonthlyReportCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

	if (cell == nil) {
		cell = [[MonthlyReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}

    if (indexPath.section == 0) {
        Account *account = self.incomeAccounts[indexPath.row];
        NSArray *totals = self.incomeTotals[account.name];

        cell.nameLbl.text = account.name;
        cell.month1Lbl.text = [[Utils numberFormatter] stringFromNumber:totals[0]];
        cell.month2Lbl.text = [[Utils numberFormatter] stringFromNumber:totals[1]];
        cell.month3Lbl.text = [[Utils numberFormatter] stringFromNumber:totals[2]];
    }
    else {
        Account *account = self.expenseAccounts[indexPath.row];
        NSArray *totals = self.expenseTotals[account.name];

        cell.nameLbl.text = account.name;
        cell.month1Lbl.text = [[Utils numberFormatter] stringFromNumber:totals[0]];
        cell.month2Lbl.text = [[Utils numberFormatter] stringFromNumber:totals[1]];
        cell.month3Lbl.text = [[Utils numberFormatter] stringFromNumber:totals[2]];
    }

	return cell;
}

@end
