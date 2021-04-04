//
//  TransactionCancelVC.m
//  PFM
//
//  Created by Metehan Karabiber on 28/03/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "TransactionCancelVC.h"
#import "TransactionItemVC.h"
#import "AccountUtils.h"
#import "TxUtils.h"
#import "TQTableViewCell.h"
#import "Account.h"
#import "Transaction.h"
#import "TransactionItem.h"

@interface TransactionCancelVC () <UIAlertViewDelegate>
@property (nonatomic) UIPopoverController *txItemPopover;
@property (nonatomic) Transaction *transaction;
@end

@implementation TransactionCancelVC

- (void) viewDidLoad {
    [super viewDidLoad];

    self.tableView.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.noReclabel.hidden = YES;
    [self.reference becomeFirstResponder];
}

- (IBAction) close:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:reloadNotification object:nil];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction) query:(id)sender {
    [self.reference resignFirstResponder];
    
    NSArray *txArray = [TxUtils fetchTransactionsWithPredicate:
                         [NSPredicate predicateWithFormat:@"tid = %@",
                          @([Utils trim:self.reference.text].doubleValue)]];
    
    self.tableView.hidden = (txArray.count == 0);
    self.noReclabel.hidden = (txArray.count > 0);

    self.transaction = txArray[0];
    [self.tableView reloadData];
}

- (IBAction) reverse:(id)sender {
	[[[UIAlertView alloc] initWithTitle:nil
								message:@"İşlemi iptal etmek istediğine emin misiniz?"
							   delegate:self
					  cancelButtonTitle:@"Hayır"
					  otherButtonTitles:@"Evet", nil] show];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex != alertView.cancelButtonIndex) {
		NSManagedObjectContext *ctx = [Utils getContext];
		
		NSNumber *newTxId = [TxUtils getNextTransactionId];
		Transaction *transactionNew = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction"
																 inManagedObjectContext:ctx];
		transactionNew.date = [NSDate date];
		transactionNew.desc = [NSString stringWithFormat:@"%d NOLU İŞLEM İPTALİ", self.transaction.tid.intValue];
		transactionNew.tid = newTxId;

        NSMutableSet *newSet = [NSMutableSet set];
        NSArray *oldItems = [self.transaction.relItems allObjects];

        for (TransactionItem *t in oldItems) {
            TransactionItem *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"TransactionItem"
                                                                     inManagedObjectContext:ctx];
            newItem.isDebit = @(!t.isDebit.boolValue);
            newItem.amount = t.amount;
            newItem.invrelItems = transactionNew;

            Account *account = t.relAccount;
            NSMutableSet *set = [account.invrelAccount mutableCopy];
            [set addObject:newItem];
            account.invrelAccount = set;
            newItem.relAccount = account;

            [newSet addObject:newItem];
            
            // Update account balance
            double currentBalance = account.balance.doubleValue;

            if ([account.subtype isEqual:@(AccountSubtypeLiability)] ||
                [account.subtype isEqual:@(AccountSubtypeIncome)]) {
                
                if (newItem.isDebit.boolValue) {
                    currentBalance -= newItem.amount.doubleValue;
                }
                else {
                    currentBalance += newItem.amount.doubleValue;
                }
            }
            else {
                if (newItem.isDebit.boolValue) {
                    currentBalance += newItem.amount.doubleValue;
                }
                else {
                    currentBalance -= newItem.amount.doubleValue;
                }
            }
            account.balance = [Utils formatString:[NSString stringWithFormat:@"%f", currentBalance]];

            // Update current year
            if ([account.subtype isEqual:@(AccountSubtypeIncome)] || [account.subtype isEqual:@(AccountSubtypeExpense)]) {
                Account *curYearAccount = [AccountUtils fetchManagedAccountWithName:currentYear];
                double curYearAccountBalance = curYearAccount.balance.doubleValue;
                
                if (newItem.isDebit.boolValue) {
                    curYearAccountBalance -= newItem.amount.doubleValue;
                }
                else {
                    curYearAccountBalance += newItem.amount.doubleValue;
                }
                curYearAccount.balance = [Utils formatString:[NSString stringWithFormat:@"%f", curYearAccountBalance]];
            }
        }
        transactionNew.relItems = newSet;
        
        // Save
        NSError *error;
        if (![ctx save:&error]) {
            [Utils showMessage:[NSString stringWithFormat:@"Bir hata oluştu:\n\n%@",[error localizedDescription]]
                        target:nil];
        }
        else {
            [Utils showMessage:@"İşlem iptal edildi!" target:nil];
            
            self.reference.text = @"";
            self.tableView.hidden = YES;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:reloadNotification object:nil];
        }
	}
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

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TCCell";
    TQTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[TQTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Transaction *tx = self.transaction;
    cell.referenceLbl.text = [NSString stringWithFormat:@"%d", self.transaction.tid.intValue];
    cell.dateLbl.text = [Utils getStringFrom:self.transaction.date];
    cell.descLbl.text = self.transaction.desc;
    
    double sum = ((NSNumber *)[tx.relItems valueForKeyPath:@"@sum.amount"]).doubleValue;
    cell.amountLbl.text = [[Utils numberFormatter] stringFromNumber:@(sum/2)];
    
    return cell;
}

- (void) tableView: (UITableView *) tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *) indexPath {
    
    Transaction *tx = self.transaction;
    
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
