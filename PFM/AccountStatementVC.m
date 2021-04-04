//
//  AccountStatementVC.m
//  PFM
//
//  Created by Metehan Karabiber on 28/03/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "AccountStatementVC.h"
#import "AccountStatementCell.h"
#import "AccountUtils.h"
#import "TxUtils.h"
#import "TransactionItemVC.h"
#import "PopoverTableVC.h"
#import "Account.h"
#import "Transaction.h"
#import "TransactionItem.h"

@import QuartzCore;

@interface AccountStatementVC ()
@property (nonatomic) UIPopoverController *accountPopover, *monthPopover, *txItemPopover;
@property (nonatomic) Account *selectedAccount;
@property (nonatomic) NSArray *transactionItems;
@end

@implementation AccountStatementVC

- (void) viewDidLoad {
    [super viewDidLoad];

    self.statementTable.hidden = YES;
    self.monthBtn.hidden = YES;
}

- (IBAction) showAccountPopover:(id)sender {
    self.statementTable.hidden = YES;

    NSArray *popArray = [AccountUtils fetchAccountsWithInactive];
    
    if (self.accountPopover && self.accountPopover.popoverVisible) {
        [self.accountPopover dismissPopoverAnimated:YES];
        self.accountPopover = nil;
    }
    else {
        if (self.accountPopover == nil) {
            PopoverTableVC *popoverTable = [[PopoverTableVC alloc] initWithArray:popArray
                                                                        delegate:self
                                                                           width:260];
            self.accountPopover = [[UIPopoverController alloc] initWithContentViewController:popoverTable];
        }
        
        [self.accountPopover presentPopoverFromBarButtonItem:self.accountBtn
                                    permittedArrowDirections:UIPopoverArrowDirectionUp
                                                    animated:NO];
        self.accountPopover.passthroughViews = nil;
    }

}

- (IBAction) showMonthPopover:(id)sender {

    if (self.monthPopover && self.monthPopover.popoverVisible) {
        [self.monthPopover dismissPopoverAnimated:YES];
        self.monthPopover = nil;
    }
    else {
        if (self.monthPopover == nil) {
            NSArray *dateArray = [[Utils getStringFrom:[NSDate date]] componentsSeparatedByString:@"."];
            int month = ((NSString *)dateArray[1]).intValue;
            int year = ((NSString *)dateArray[2]).intValue;

            NSMutableArray *monthArray = [NSMutableArray new];

            for (int i = 1; i <= month; i++) {
                [monthArray addObject:[NSString stringWithFormat:@"%@ %d", months[i-1], year]];
            }

            PopoverTableVC *popoverTable = [[PopoverTableVC alloc] initWithArray:monthArray
                                                                        delegate:self
                                                                           width:200];
            self.monthPopover = [[UIPopoverController alloc] initWithContentViewController:popoverTable];
        }
        
        [self.monthPopover presentPopoverFromRect:((UIButton*)sender).frame
                                           inView:self.view
                         permittedArrowDirections:UIPopoverArrowDirectionUp
                                         animated:NO];
        self.monthPopover.passthroughViews = nil;
    }
}

- (IBAction) close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) popoverSelected:(id)object source:(UIControl *)src {
    if ([object isKindOfClass:[Account class]]) {
        self.selectedAccount = object;
        self.accountBtn.title = self.selectedAccount.name;
        self.monthBtn.hidden = NO;

        [self.accountPopover dismissPopoverAnimated:NO];
        self.accountPopover = nil;
    }
    else if ([object isKindOfClass:[NSString class]]) {
        [self.monthPopover dismissPopoverAnimated:NO];
        self.monthPopover = nil;

        NSString *month = [object substringToIndex:((NSString*)object).length-5];
        int index;
        for (int i = 0; i < 12; i++) {
            if ([month isEqualToString:months[i]]) {
                index = i;
                break;
            }
        }

        NSString *monthStr = ((index+1) < 10) ? [NSString stringWithFormat:@"0%d", index+1] : [NSString stringWithFormat:@"%d", index+1];
        NSString *yearStr = [(NSString*)object substringFromIndex:5];
        NSDate *startDate = [Utils getDateFrom:[NSString stringWithFormat:@"01.%@.%@", monthStr, yearStr]];
        NSDate *endDate = [Utils getDateFrom:[NSString stringWithFormat:@"%ld.%@.%@", [Utils getNumberOfDays:startDate], monthStr, yearStr]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relAccount = %@ AND invrelItems.date >= %@ AND invrelItems.date <= %@",
                                  self.selectedAccount, startDate, endDate];

        self.transactionItems = [TxUtils fetchTransactionItemsWithPredicate:predicate];

        [self.statementTable reloadData];
        self.statementTable.hidden = NO;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:[self.statementTable headerViewForSection:section].frame];
    view.backgroundColor = [UIColor whiteColor];

    UILabel *referenceLbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 60, 44)];
    referenceLbl.text = @"REF #";
    referenceLbl.textAlignment = NSTextAlignmentCenter;
    referenceLbl.font = [UIFont boldSystemFontOfSize:17];
    referenceLbl.textColor = [UIColor blackColor];
    [view addSubview:referenceLbl];
    
    UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(68, 0, 100, 44)];
    dateLbl.text = @"TARIH";
    dateLbl.textAlignment = NSTextAlignmentCenter;
    dateLbl.font = [UIFont boldSystemFontOfSize:17];
    dateLbl.textColor = [UIColor blackColor];
    [view addSubview:dateLbl];
    
    UILabel *amountLbl = [[UILabel alloc] initWithFrame:CGRectMake(168, 0, 120, 44)];
    amountLbl.text = @"TUTAR";
    amountLbl.textAlignment = NSTextAlignmentCenter;
    amountLbl.font = [UIFont boldSystemFontOfSize:17];
    amountLbl.textColor = [UIColor blackColor];
    [view addSubview:amountLbl];
    
    UILabel *descLbl = [[UILabel alloc] initWithFrame:CGRectMake(296, 0, 392, 44)];
    descLbl.text = @"AÇIKLAMA";
    descLbl.textAlignment = NSTextAlignmentLeft;
    descLbl.font = [UIFont boldSystemFontOfSize:17];
    descLbl.textColor = [UIColor blackColor];
    [view addSubview:descLbl];
    
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 46, 696, 2)];
    bottomBorder.backgroundColor = [UIColor blackColor];
    [view addSubview:bottomBorder];
    [view bringSubviewToFront:bottomBorder];

    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UIView *view = [[UIView alloc] initWithFrame:[self.statementTable footerViewForSection:section].frame];
	view.backgroundColor = [UIColor whiteColor];

    UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 696, 1)];
    topBorder.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:topBorder];
    [view bringSubviewToFront:topBorder];
    
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 152, 44)];
	label.text = @"GÜNCEL BAKİYE:";
	label.textAlignment = NSTextAlignmentRight;
	label.font = [UIFont boldSystemFontOfSize:17];
	label.textColor = [UIColor blackColor];
	[view addSubview:label];

    UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(168, 0, 120, 44)];
    balanceLabel.textAlignment = NSTextAlignmentRight;
    balanceLabel.font = [UIFont boldSystemFontOfSize:17];
    balanceLabel.textColor = [UIColor blackColor];
    balanceLabel.text = [[Utils numberFormatter] stringFromNumber:self.selectedAccount.balance];
    [view addSubview:balanceLabel];

    return view;
}

// UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.transactionItems.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"StatementCell";
    AccountStatementCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[AccountStatementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    TransactionItem *item = self.transactionItems[indexPath.row];
    cell.referenceLbl.text = [NSString stringWithFormat:@"%d", item.invrelItems.tid.intValue];
    cell.dateLbl.text = [Utils getStringFrom:item.invrelItems.date];
    cell.amountLbl.text = [[Utils numberFormatter] stringFromNumber:item.amount];
    cell.descLbl.text = item.invrelItems.desc;

    Account *account = item.relAccount;
    if (([account.subtype isEqual:@(AccountSubtypeAsset)] || [account.subtype isEqual:@(AccountSubtypeDual)]) && !item.isDebit.boolValue) {
        cell.amountLbl.textColor = [UIColor redColor];
    }
    else if ([account.subtype isEqual:@(AccountSubtypeLiability)] && item.isDebit.boolValue) {
		cell.amountLbl.textColor = [UIColor colorWithRed:52/255 green:0.8 blue:52/255 alpha:1];
    }
    else if ([account.subtype isEqual:@(AccountSubtypeIncome)] && item.isDebit.boolValue) {
        cell.amountLbl.textColor = [UIColor redColor];
    }
    else if ([account.subtype isEqual:@(AccountSubtypeExpense)] && !item.isDebit.boolValue) {
        cell.amountLbl.textColor = [UIColor colorWithRed:52/255 green:0.8 blue:52/255 alpha:1];
    }
    else {
        cell.amountLbl.textColor = [UIColor blackColor];
    }

    return cell;
}

- (void) tableView: (UITableView *) tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *) indexPath {
    
    TransactionItem *item = self.transactionItems[indexPath.row];
    Transaction *tx = item.invrelItems;
    
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
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [self.txItemPopover presentPopoverFromRect:CGRectMake(660, 22, 1, 1)
                                            inView:cell.contentView
                          permittedArrowDirections:UIPopoverArrowDirectionRight
                                          animated:YES];
        
        self.txItemPopover.passthroughViews = nil;
    }
}

@end
