//
//  AccountCreateVC.m
//  PFM
//
//  Created by Metehan Karabiber on 12/03/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "AccountCreateVC.h"
#import "AccountUtils.h"
#import "TxUtils.h"
#import "Account.h"
#import "Transaction.h"
#import "TransactionItem.h"

@implementation AccountCreateVC

- (void) viewDidLoad {
    [super viewDidLoad];

	[self reset];
}

- (IBAction) accountTypeSelected:(id)sender {
    self.accountSubtypeLbl.hidden = NO;
    
    BOOL bsSelected = (self.accountType.selectedSegmentIndex == 0);
    
    self.accountBSSubtype.hidden = !bsSelected;
    self.dualHelp.hidden = !bsSelected;
    self.accountBSSubtype.selectedSegmentIndex = UISegmentedControlNoSegment;
    self.accountITSubtype.hidden = bsSelected;
    self.accountITSubtype.selectedSegmentIndex = UISegmentedControlNoSegment;
    
    self.accountGroupLbl.hidden = YES;
    self.accountGroupActive.hidden = YES;
    self.accountGroupPassive.hidden = YES;
    
    self.accountBalanceLbl.hidden = YES;
    self.accountBalanceDescLbl.hidden = YES;
    self.accountBalance.hidden = YES;
}

- (IBAction) accountSubtypeSelected:(id)sender {
    if (sender == self.accountBSSubtype) {
        if (self.accountBSSubtype.selectedSegmentIndex == 0) {
            self.accountGroupLbl.hidden = NO;
            self.accountGroupActive.hidden = NO;
            self.accountGroupPassive.hidden = YES;
        }
        else if (self.accountBSSubtype.selectedSegmentIndex == 1) {
            self.accountGroupLbl.hidden = NO;
            self.accountGroupActive.hidden = YES;
            self.accountGroupPassive.hidden = NO;
        }
        else {
            self.accountGroupLbl.hidden = YES;
            self.accountGroupActive.hidden = YES;
            self.accountGroupPassive.hidden = YES;
        }
        
        self.accountGroupActive.selectedSegmentIndex = UISegmentedControlNoSegment;
        self.accountGroupPassive.selectedSegmentIndex = UISegmentedControlNoSegment;
        
        self.accountBalanceLbl.hidden = NO;
		self.accountBalanceDescLbl.hidden = NO;
        self.accountBalance.hidden = NO;
    }
}

- (IBAction) save:(id)sender {
	NSString *name = [Utils trim:self.accountName.text];

	if ([name isEqualToString:@""]) {
		[Utils showMessage:@"Hesap adını boş bırakmayın" target:nil];
		return;
	}
    else if (name.length > 25) {
        [Utils showMessage:@"Hesap adı 25 karakteri geçmemli!" target:nil];
        return;
    }
	else {
		Account *account = [AccountUtils fetchManagedAccountWithName:name];

		if (account != nil) {
			[Utils showMessage:@"Hesap adı zaten mevcut" target:nil];
			return;
		}
	}
	
	if (self.accountType.selectedSegmentIndex == UISegmentedControlNoSegment) {
		[Utils showMessage:@"Hesap tipini seçin" target:nil];
		return;
	}
	if (self.accountBSSubtype.selectedSegmentIndex == UISegmentedControlNoSegment &&
		self.accountITSubtype.selectedSegmentIndex == UISegmentedControlNoSegment) {
		[Utils showMessage:@"Hesap alt tipini seçin" target:nil];
		return;
	}
	
	if (self.accountBSSubtype.selectedSegmentIndex != UISegmentedControlNoSegment) {
		if (self.accountBSSubtype.selectedSegmentIndex != 2) {
			
			if (self.accountGroupActive.selectedSegmentIndex == UISegmentedControlNoSegment &&
				self.accountGroupPassive.selectedSegmentIndex == UISegmentedControlNoSegment) {
				[Utils showMessage:@"Hesap grubunu seçin" target:nil];
				return;
			}
		}
	}
	
	if (![Utils isEmpty:self.accountBalance]) {
		if (![Utils validateAmount:self.accountBalance.text]) {
			[Utils showMessage:@"Geçersiz tutar girdiniz!" target:nil];
			return;
		}
	}

	NSManagedObjectContext *ctx = [Utils getContext];
    Account *account = [NSEntityDescription insertNewObjectForEntityForName:@"Account"
                                                     inManagedObjectContext:ctx];
    account.name = [name uppercaseString];
	if ([Utils isEmpty:self.accountBalance]) {
		account.balance = @0.00;
	}
	else {
		account.balance = [Utils formatString:self.accountBalance.text];
	}

    account.isActive = @YES;
    account.type = @((self.accountType.selectedSegmentIndex == 0) ? AccountTypeBalanceSheet : AccountTypeIncomeTable);

    AccountSubtype accSubtype;
	AccountGroup group;
    if ([account.type isEqual:@(AccountTypeBalanceSheet)]) {

        if (self.accountBSSubtype.selectedSegmentIndex == 0) {
            accSubtype = AccountSubtypeAsset;
			group = (self.accountGroupActive.selectedSegmentIndex == 0) ? AccountGroupCurrentAsset : AccountGroupFixedAsset;
        }
        else if (self.accountBSSubtype.selectedSegmentIndex == 1) {
            accSubtype = AccountSubtypeLiability;
			group = (self.accountGroupPassive.selectedSegmentIndex == 0) ? AccountGroupShortTerm : AccountGroupLongTerm;
        }
        else {
            accSubtype = AccountSubtypeDual;
			group = -1;
        }
        account.subtype = @(accSubtype);
        account.group = @(group);
    }
    else {
		account.subtype = @((self.accountITSubtype.selectedSegmentIndex == 0) ? AccountSubtypeIncome : AccountSubtypeExpense);
		account.group = @(-1);
    }

	// Transaction
	NSNumber *nextId = [TxUtils getNextTransactionId];
	Transaction *transaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction"
															 inManagedObjectContext:ctx];
	transaction.desc = @"HESAP AÇILIŞI";
	transaction.date = [NSDate date];
	transaction.tid = nextId;

	NSMutableSet *transactionItems = [[NSMutableSet alloc] init];

	TransactionItem *item1 = [NSEntityDescription insertNewObjectForEntityForName:@"TransactionItem"
														  inManagedObjectContext:ctx];
	item1.amount = account.balance;
	item1.relAccount = account;
	item1.invrelItems = transaction;

	NSMutableSet *accSet = [account.invrelAccount mutableCopy];
	[accSet addObject:item1];
	account.invrelAccount = accSet;

	BOOL isActive = NO;
	if ([account.subtype isEqual:@(AccountSubtypeDual)]) {
		isActive = (account.balance.doubleValue >= 0);
	}
	else {
		isActive = [account.subtype isEqual:@(AccountSubtypeAsset)];
	}
	item1.isDebit = @(isActive);
	[transactionItems addObject:item1];

	Account *capitalAcc = [AccountUtils fetchManagedAccountWithName:startingcapital];

	TransactionItem *item2 = [NSEntityDescription insertNewObjectForEntityForName:@"TransactionItem"
														  inManagedObjectContext:ctx];
	item2.amount = account.balance;
	item2.relAccount = capitalAcc;
	item2.invrelItems = transaction;
	item2.isDebit = @(!isActive);
	
	NSMutableSet *capSet = [capitalAcc.invrelAccount mutableCopy];
	[capSet addObject:item2];
	capitalAcc.invrelAccount = capSet;

	[transactionItems addObject:item2];
	transaction.relItems = transactionItems;
	
	// Update capital balance
	double capitalBalance = capitalAcc.balance.doubleValue;
	if (isActive || (!isActive && [account.subtype isEqual:@(AccountSubtypeDual)])) {
		capitalBalance += account.balance.doubleValue;
	}
	else {
		capitalBalance -= account.balance.doubleValue;
	}
	capitalAcc.balance = @(capitalBalance);

    // Save
	NSError *error;
	if (![ctx save:&error]) {
		[Utils showMessage:[NSString stringWithFormat:@"Bir hata oluştu:\n\n%@",[error localizedDescription]]
					target:nil];
	}
	else {
		[Utils showMessage:@"Hesap başarıyla yaratıldı!" target:nil];

		[self reset];
		[[NSNotificationCenter defaultCenter] postNotificationName:reloadNotification object:nil];
	}
}

- (void) reset {
	self.accountName.text = @"";
	self.accountType.selectedSegmentIndex = UISegmentedControlNoSegment;
	self.accountBSSubtype.selectedSegmentIndex = UISegmentedControlNoSegment;
	self.accountITSubtype.selectedSegmentIndex = UISegmentedControlNoSegment;
	self.accountGroupActive.selectedSegmentIndex = UISegmentedControlNoSegment;
	self.accountGroupPassive.selectedSegmentIndex = UISegmentedControlNoSegment;
	
	self.accountSubtypeLbl.hidden = YES;
	self.accountBSSubtype.hidden = YES;
	self.accountITSubtype.hidden = YES;
    self.dualHelp.hidden = YES;
	
	self.accountGroupLbl.hidden = YES;
	self.accountGroupActive.hidden = YES;
	self.accountGroupPassive.hidden = YES;
    
    self.accountBalanceLbl.hidden = YES;
	self.accountBalanceDescLbl.hidden = YES;
    self.accountBalance.hidden = YES;
    self.accountBalance.text = @"";
	
	[self.accountName becomeFirstResponder];
}

- (IBAction) cancel:(id)sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

@end
