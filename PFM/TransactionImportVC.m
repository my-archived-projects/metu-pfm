//
//  ActionViewController.m
//  PFM Tx Importer
//
//  Created by Metehan Karabiber on 4/5/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "TransactionImportVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "BankAccountCell.h"
#import "Account.h"
#import "Transaction.h"
#import "TransactionItem.h"
#import "AccountUtils.h"
#import "TxUtils.h"
#import "Utils.h"
#import "PopoverTableVC.h"
#import "PopoverTableDelegate.h"

#define BANK_TITLES @[@"YATAN", @"ÇEKİLEN"]
#define CARD_TITLES @[@"ÖDEME", @"HARCAMA"]
#define EMPTY @""

@implementation Tx
@end

@interface TransactionImportVC() <UITextFieldDelegate, PopoverTableDelegate>
@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic, weak) IBOutlet UILabel *topLabel;
@property(nonatomic, weak) IBOutlet UIButton *accButton;
@property(nonatomic) NSArray *assetAccounts, *dualAccounts, *liabAccounts, *headerTitles;
@property(nonatomic) NSMutableArray *againstAccounts;
@property(nonatomic) UIPopoverController *accountsPopover;
@property(nonatomic) Account *mainAccount;

- (IBAction) done;
- (IBAction) transfer;
- (IBAction) accountSelector:(id)sender;
- (void) againstAccSelector:(id)sender;
@end

@implementation TransactionImportVC

- (void) viewDidLoad {
    [super viewDidLoad];

	self.againstAccounts = [[NSMutableArray alloc] initWithCapacity:self.transactions.count];
	// Fill array with dummy objects to prevent array index out of bound exception
	for (int i = 0; i < self.transactions.count; i++) {
		self.againstAccounts[i] = EMPTY;
	}
	
	self.topLabel.text = [NSString stringWithFormat:@"%d işlem bulundu. Bu işlemlerin ait olduğu hesabı seçin =>", (int)self.transactions.count];
	self.topLabel.hidden = NO;
	self.accButton.hidden = NO;
}

- (IBAction) transfer {
	if ([self.againstAccounts containsObject:EMPTY]) {
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
																	   message:@"Karşı hesaplarda eksikler var, tamamı seçilmeli!"
																preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* action = [UIAlertAction actionWithTitle:@"Tamam"
															   style:UIAlertActionStyleDefault
															 handler:^(UIAlertAction * action) {
																 [alert dismissViewControllerAnimated:YES completion:NULL];
															 }];
		[alert addAction:action];
		[self presentViewController:alert animated:YES completion:nil];
		return;
	}

	[self.tableView endEditing:YES];

	UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
																   message:[NSString stringWithFormat:@"%d işlemi transfer etmeyi onaylıyor musunuz?", (int)self.transactions.count]
															preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:@"Hayır"
											  style:UIAlertActionStyleCancel
											handler:^(UIAlertAction * action) {
												[alert dismissViewControllerAnimated:YES completion:NULL];
											}]];
	[alert addAction:[UIAlertAction actionWithTitle:@"Evet"
											  style:UIAlertActionStyleDefault
											handler:^(UIAlertAction * action) {
												[alert dismissViewControllerAnimated:YES completion:NULL];
												[self completeTransfer];
											}]];
	[self presentViewController:alert animated:YES completion:nil];
}

- (void) completeTransfer {
	NSManagedObjectContext *ctx = [Utils getContext];

	for (int i = 0; i < self.transactions.count; i++) {
		Tx *tx = self.transactions[i];
		NSNumber *txAmount = (tx.debitAmt != nil) ? [Utils formatString:tx.debitAmt] : [Utils formatString:tx.creditAmt];
		
		NSNumber *nextId = [TxUtils getNextTransactionId];
		Transaction *transaction = (Transaction *)[NSEntityDescription insertNewObjectForEntityForName:@"Transaction"
																				inManagedObjectContext:ctx];
		transaction.tid = nextId;
		transaction.date = [Utils getDateFrom:tx.date];
		transaction.desc = tx.desc;

		NSMutableSet *transactionItems = [[NSMutableSet alloc] init];

		TransactionItem *item1 = (TransactionItem *)[NSEntityDescription insertNewObjectForEntityForName:@"TransactionItem"
																				  inManagedObjectContext:ctx];
		Account *account1 = self.mainAccount;
		item1.relAccount = account1;
		item1.isDebit = @(tx.debitAmt != nil);
		item1.invrelItems = transaction;
		item1.amount = txAmount;

		NSMutableSet *set1 = [account1.invrelAccount mutableCopy];
		[set1 addObject:item1];
		account1.invrelAccount = set1;
		[transactionItems addObject:item1];

		// Update account balance
		double currentBalance = account1.balance.doubleValue;
		
		if ([account1.subtype isEqual:@(AccountSubtypeAsset)] || [account1.subtype isEqual:@(AccountSubtypeDual)]) {
			if (item1.isDebit.boolValue) {
				currentBalance += item1.amount.doubleValue;
			}
			else {
				currentBalance -= item1.amount.doubleValue;
			}
		}
		else {
			if (item1.isDebit.boolValue) {
				currentBalance -= item1.amount.doubleValue;
			}
			else {
				currentBalance += item1.amount.doubleValue;
			}
		}
		account1.balance = [Utils formatString:[NSString stringWithFormat:@"%f", currentBalance]];

		TransactionItem *item2 = (TransactionItem *) [NSEntityDescription insertNewObjectForEntityForName:@"TransactionItem"
																				  inManagedObjectContext:ctx];
		Account *account2 = (Account *)[[Utils getContext] objectWithID:self.againstAccounts[i]];
		item2.relAccount = account2;
		item2.isDebit = @(!item1.isDebit.boolValue);
		item2.invrelItems = transaction;
		item2.amount = txAmount;

		NSMutableSet *set2 = [account2.invrelAccount mutableCopy];
		[set2 addObject:item2];
		account2.invrelAccount = set2;
		[transactionItems addObject:item2];
		
		// Update account balance
		currentBalance = account2.balance.doubleValue;

		if ([account2.subtype isEqual:@(AccountSubtypeLiability)] || [account2.subtype isEqual:@(AccountSubtypeIncome)]) {
			if (!item2.isDebit.boolValue) {
				currentBalance += item2.amount.doubleValue;
			}
			else {
				currentBalance -= item2.amount.doubleValue;
			}
		}
		else {
			if (item2.isDebit.boolValue) {
				currentBalance += item2.amount.doubleValue;
			}
			else {
				currentBalance -= item2.amount.doubleValue;
			}
		}
		account2.balance = [Utils formatString:[NSString stringWithFormat:@"%f", currentBalance]];

		// Update current year
		if ([account2.subtype isEqual:@(AccountSubtypeIncome)] || [account2.subtype isEqual:@(AccountSubtypeExpense)]) {
			BOOL isIncome = [account2.subtype isEqual:@(AccountSubtypeIncome)];
			Account *curYearAccount = [AccountUtils fetchManagedAccountWithName:currentYear];
			double curYearAccountBalance = curYearAccount.balance.doubleValue;
			if ((!isIncome && item2.isDebit.boolValue) || (isIncome && !item2.isDebit.boolValue)) {
				curYearAccountBalance += item2.amount.doubleValue;
			}
			else {
				curYearAccountBalance -= item2.amount.doubleValue;
			}
			curYearAccount.balance = [Utils formatString:[NSString stringWithFormat:@"%f", curYearAccountBalance]];
		}
		
		transaction.relItems = transactionItems;
	}

	// Save
	NSError *error;
	if (![ctx save:&error]) {
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
																	   message:[NSString stringWithFormat:@"Bir hata oluştu:\n\n%@", [error localizedDescription]]
																preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"Tamam"
												  style:UIAlertActionStyleDefault
												handler:^(UIAlertAction * action) {
													[alert dismissViewControllerAnimated:YES completion:NULL];
												}]];
		[self presentViewController:alert animated:YES completion:^{
			// Reset
			self.transactions = nil;
			self.assetAccounts = nil;
			self.dualAccounts = nil;
			self.liabAccounts = nil;
			self.topLabel.hidden = YES;
			self.accButton.hidden = YES;
			self.tableView.hidden = YES;
			[self.tableView reloadData];
		}];
	}
	else {
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
																	   message:@"İşlemler başarıyla kaydedildi!"
																preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"Tamam"
												  style:UIAlertActionStyleDefault
												handler:^(UIAlertAction * action) {
													[[NSNotificationCenter defaultCenter] postNotificationName:reloadNotification
																										object:nil];
													[alert dismissViewControllerAnimated:YES completion:NULL];
													[self done];
												}]];
		[self presentViewController:alert animated:YES completion:^{
			// Reset
			self.transactions = nil;
			self.assetAccounts = nil;
			self.dualAccounts = nil;
			self.liabAccounts = nil;
			self.topLabel.hidden = YES;
			self.accButton.hidden = YES;
			self.tableView.hidden = YES;
			[self.tableView reloadData];
		}];
	}
}

- (IBAction) accountSelector:(id)sender {
	if (self.accountsPopover && self.accountsPopover.isPopoverVisible) {
		[self.accountsPopover dismissPopoverAnimated:YES];
		self.accountsPopover = nil;
	}
	else {
		if (self.accountsPopover == nil) {
			self.assetAccounts = [AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"subtype = %@",@(AccountSubtypeAsset)]];
			self.liabAccounts = [AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"subtype = %@",@(AccountSubtypeLiability)]];
			self.dualAccounts = [AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"subtype = %@",@(AccountSubtypeDual)]];

			NSMutableArray *accounts = [NSMutableArray arrayWithArray:self.assetAccounts];
			[accounts addObjectsFromArray:self.liabAccounts];
			[accounts addObjectsFromArray:self.dualAccounts];

			PopoverTableVC *popoverTable = [[PopoverTableVC alloc] initWithArray:accounts
																		delegate:self
																		   width:256];
			popoverTable.popoverSource = self.accButton;
			self.accountsPopover = [[UIPopoverController alloc] initWithContentViewController:popoverTable];
		}

		[self.accountsPopover presentPopoverFromRect:self.accButton.frame
											  inView:self.view
							permittedArrowDirections:UIPopoverArrowDirectionUp
											animated:YES];
		self.accountsPopover.passthroughViews = nil;
	}
}

- (void) againstAccSelector:(id)sender {
	if (self.accountsPopover && self.accountsPopover.isPopoverVisible) {
		[self.accountsPopover dismissPopoverAnimated:YES];
		self.accountsPopover = nil;
	}
	else {
		if (self.accountsPopover == nil) {
			PopoverTableVC *popoverTable = [[PopoverTableVC alloc] initWithArray:[AccountUtils fetchAccounts]
																		delegate:self
																		   width:256];
			popoverTable.popoverSource = (UIButton *)sender;
			self.accountsPopover = [[UIPopoverController alloc] initWithContentViewController:popoverTable];
		}
		
		[self.accountsPopover presentPopoverFromRect:((UIButton*)sender).frame
											  inView:[((UIButton*)sender) superview]
							permittedArrowDirections:UIPopoverArrowDirectionUp
											animated:YES];
		self.accountsPopover.passthroughViews = nil;
	}
}

- (void) popoverSelected:(id)object source:(UIControl *)src {
	if (src == self.accButton) {
		self.mainAccount = object;
		[self.accButton setTitle:self.mainAccount.name forState:UIControlStateNormal];
		[self.accountsPopover dismissPopoverAnimated:YES];
		self.accountsPopover = nil;

		self.headerTitles = [self.liabAccounts containsObject:self.mainAccount] ? CARD_TITLES : BANK_TITLES;

		[self.tableView reloadData];
		self.tableView.hidden = NO;
	}
	else {
		[self.accountsPopover dismissPopoverAnimated:YES];
		self.accountsPopover = nil;

		Account *acc = object;
		UIButton *againstAccBtn = (UIButton *)src;
		[againstAccBtn setTitle:acc.name forState:UIControlStateNormal];
		self.againstAccounts[againstAccBtn.tag - 1000] = acc.objectID;
	}
}

- (IBAction) done {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

@end

@implementation TransactionImportVC (Textfield)

- (void) textFieldDidEndEditing:(UITextField *)textField {
	NSInteger index = textField.tag - 1000;
	
	Tx *tx = self.transactions[index];
	tx.desc = textField.text;
}

@end

@implementation TransactionImportVC (TableView)

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 48;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = [[UIView alloc] initWithFrame:[self.tableView headerViewForSection:section].frame];
	view.backgroundColor = [UIColor whiteColor];
	
	UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 82, 48)];
	dateLbl.textAlignment = NSTextAlignmentCenter;
	dateLbl.font = [UIFont boldSystemFontOfSize:16];
	dateLbl.textColor = [UIColor blackColor];
	dateLbl.text = @"TARİH";
	[view addSubview:dateLbl];
	
	UILabel *debitAmtLbl = [[UILabel alloc] initWithFrame:CGRectMake(98, 0, 100, 48)];
	debitAmtLbl.textAlignment = NSTextAlignmentRight;
	debitAmtLbl.font = [UIFont boldSystemFontOfSize:16];
	debitAmtLbl.textColor = [UIColor blackColor];
	debitAmtLbl.text = self.headerTitles[0];
	[view addSubview:debitAmtLbl];
	
	UILabel *creditAmtLbl = [[UILabel alloc] initWithFrame:CGRectMake(206, 0, 100, 48)];
	creditAmtLbl.textAlignment = NSTextAlignmentRight;
	creditAmtLbl.font = [UIFont boldSystemFontOfSize:16];
	creditAmtLbl.textColor = [UIColor blackColor];
	creditAmtLbl.text = self.headerTitles[1];
	[view addSubview:creditAmtLbl];

	UILabel *againstAcc = [[UILabel alloc] initWithFrame:CGRectMake(314, 0, 200, 48)];
	againstAcc.textAlignment = NSTextAlignmentCenter;
	againstAcc.font = [UIFont boldSystemFontOfSize:16];
	againstAcc.textColor = [UIColor blackColor];
	againstAcc.text = @"KARŞI HESAP";
	[view addSubview:againstAcc];

	UILabel *descLbl = [[UILabel alloc] initWithFrame:CGRectMake(522, 0, 222, 48)];
	descLbl.textAlignment = NSTextAlignmentLeft;
	descLbl.font = [UIFont boldSystemFontOfSize:16];
	descLbl.textColor = [UIColor blackColor];
	descLbl.text = @"TARİH";
	[view addSubview:descLbl];

	UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 46, 752, 2)];
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
	static NSString *cellIdentifier = @"TransferCell";
	BankAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil) {
		cell = [[BankAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
	Tx *tx = self.transactions[indexPath.row];
	cell.dateLbl.text = tx.date;
	cell.debitAmtLbl.text = tx.debitAmt;
	cell.creditAmtLbl.text = tx.creditAmt;

	[cell.againstAcc addTarget:self action:@selector(againstAccSelector:) forControlEvents:UIControlEventTouchUpInside];
	cell.againstAcc.tag = 1000 + indexPath.row;

	cell.descTxt.text = tx.desc;
	cell.descTxt.delegate = self;
	cell.descTxt.tag = 1000 + indexPath.row;
	
	return cell;
}

@end
