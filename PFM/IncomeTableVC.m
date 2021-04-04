//
//  IncomeTableVC.m
//  PFM
//
//  Created by Metehan Karabiber on 28/03/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "IncomeTableVC.h"
#import "AccountUtils.h"
#import "IncomeTableViewCell.h"
#import "PieChartViewController.h"
#import "Account.h"

@interface IncomeTableVC ()
@property (nonatomic) NSArray *incomeAccounts, *expenseAccounts;
@end

@implementation IncomeTableVC

- (void) viewDidLoad {
    [super viewDidLoad];
	
	self.incomeAccounts = [AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"subtype = %@",
																	@(AccountSubtypeIncome)]];
	self.expenseAccounts = [AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"subtype = %@",
																	@(AccountSubtypeExpense)]];
	self.header.text = [NSString stringWithFormat:@"%@ itibariyle Gelir Tablosu", [Utils getStringFrom:[NSDate date]]];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = nil;
}

- (IBAction) close:(id)sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction) showChart:(id)sender {
	PieChartViewController *vc = [[PieChartViewController alloc] initWithNibName:@"PieChartViewController" bundle:nil];
	vc.modalPresentationStyle = UIModalPresentationCurrentContext;
	vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	
	[self presentViewController:vc animated:YES completion:NULL];
}

@end

@implementation IncomeTableVC(TableView)

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 534, 48)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.backgroundColor = [UIColor whiteColor];
    label.text = (section == 0) ? @"   GELİR HESAPLARI" : @"   GİDER HESAPLARI";
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor colorWithRed:0 green:0.71 blue:0.98 alpha:1];
    [view addSubview:label];
    
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 46, 534, 2)];
    bottomBorder.backgroundColor = [UIColor blackColor];
    [view addSubview:bottomBorder];
    [view bringSubviewToFront:bottomBorder];
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:[tableView footerViewForSection:section].frame];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 300, 44)];
    label.text = @"TOPLAM:";
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont boldSystemFontOfSize:17];
    label.textColor = [UIColor blackColor];
    [view addSubview:label];
    
    UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(380, 0, 140, 44)];
    balanceLabel.textAlignment = NSTextAlignmentRight;
    balanceLabel.font = [UIFont boldSystemFontOfSize:17];
    balanceLabel.textColor = [UIColor blackColor];
    
    NSNumber *sum;
    if (section == 0) {
        sum = (NSNumber *)[self.incomeAccounts valueForKeyPath:@"@sum.balance"];
    }
    else {
        sum = (NSNumber *)[self.expenseAccounts valueForKeyPath:@"@sum.balance"];
    }
    balanceLabel.text = [[Utils numberFormatter] stringFromNumber:sum];
    
    [view addSubview:balanceLabel];
    
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? self.incomeAccounts.count : self.expenseAccounts.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"IncomeTableViewCell";
    IncomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[IncomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    Account *account = (indexPath.section == 0) ? self.incomeAccounts[indexPath.row] : self.expenseAccounts[indexPath.row];
    cell.accountName.text = account.name;
    cell.accountBalance.text = [[Utils numberFormatter] stringFromNumber:account.balance];
    
    return cell;
}

@end
