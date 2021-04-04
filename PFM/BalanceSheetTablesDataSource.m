//
//  BalanceSheetTablesDataSource.m
//  PFM
//
//  Created by Metehan Karabiber on 3/1/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#define ACTIVE_HEADERS @[@"MENKULLER & ALACAKLAR", @"GAYRİ MENKULLER"]
#define PASSIVE_HEADERS @[@"KISA VADELİ BORÇLAR", @"UZUN VADELİ BORÇLAR", @"ÖZ KAYNAKLAR"]

#import "BalanceSheetTablesDataSource.h"
#import "BSTableViewCell.h"
#import "AccountUtils.h"
#import "Account.h"

@interface BalanceSheetTablesDataSource()
@property (nonatomic, assign) UITableView *activeTable, *passiveTable;
@end

@implementation BalanceSheetTablesDataSource

- (instancetype) initWithActiveTable:(UITableView *)atv passiveTable:(UITableView *)ptv {
    self = [super init];
    self.activeTable = atv;
    self.passiveTable = ptv;
    return self;
}

// UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 48;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    NSString *header = (tableView == self.activeTable) ? ACTIVE_HEADERS[section] : PASSIVE_HEADERS[section];
	label.text = [NSString stringWithFormat:@"  %@", header];
	label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor colorWithRed:0 green:0.71 blue:0.98 alpha:1];
    [label sizeToFit];

	return label;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 44;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	double sum = 0;
	if (tableView == self.activeTable) {
		if (section == 0) sum = ((NSNumber *)[self.curAssets valueForKeyPath:@"@sum.balance"]).doubleValue;
		else if (section == 1) sum = ((NSNumber *)[self.fixedAssets valueForKeyPath:@"@sum.balance"]).doubleValue;
	}
	else {
		if (section == 0) {
			for (Account *account in self.shortLiabilities) {
				sum += fabs(account.balance.doubleValue);
			}
		}
		else if (section == 1) sum = ((NSNumber *)[self.longLiabilities valueForKeyPath:@"@sum.balance"]).doubleValue;
		else if (section == 2) sum = ((NSNumber *)[self.capitals valueForKeyPath:@"@sum.balance"]).doubleValue;
	}

	CGRect footerFrame = [tableView rectForFooterInSection:section];
	CGRect labelFrame = CGRectMake(0, 0, footerFrame.size.width - 8, 44);
	
	UIView *footer = [[UIView alloc] initWithFrame:footerFrame];
	UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
	label.font = [UIFont boldSystemFontOfSize:17];
	label.textAlignment = NSTextAlignmentRight;
	label.text = [NSString stringWithFormat:@"%@", [[Utils numberFormatter] stringFromNumber:@(sum)]];

	[footer addSubview:label];
	return footer;
}

// UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return (tableView == self.activeTable) ? 2 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.activeTable) {
		return (section == 0) ? self.curAssets.count : self.fixedAssets.count;
	}
	else {
		if (section == 0) return self.shortLiabilities.count;
		if (section == 1) return self.longLiabilities.count;
		if (section == 2) return self.capitals.count;
	}
	return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"BalanceSheetCell";
	BSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

	if (cell == nil) {
		cell = [[BSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}

	Account *account;

	if (tableView == self.activeTable) {
		account = (indexPath.section == 0) ? self.curAssets[indexPath.row] : self.fixedAssets[indexPath.row];
	}
	else {
		if (indexPath.section == 0) {
			account = self.shortLiabilities[indexPath.row];
		}
		else if (indexPath.section == 1) {
			account = self.longLiabilities[indexPath.row];
		}
        else if (indexPath.section == 2) {
            account = self.capitals[indexPath.row];
        }
    }

	double balance = [account.subtype isEqual:@(AccountSubtypeDual)] ? fabs(account.balance.doubleValue) : account.balance.doubleValue;

    cell.accountName.text = account.name;
    cell.accountBalance.text = [[Utils numberFormatter] stringFromNumber:@(balance)];
    
	return cell;
}

@end
