//
//  TransactionVC.m
//  PFM
//
//  Created by Metehan Karabiber on 3/21/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "TransactionVC.h"
#import "TxLabels.h"
#import "PopoverTableVC.h"
#import "AccountUtils.h"
#import "TxUtils.h"
#import "Account.h"
#import "Transaction.h"
#import "TransactionItem.h"

@import QuartzCore;

@interface TransactionVC ()
@property (nonatomic) NSArray *debitAccounts, *debitAccountAmts, *creditAccounts, *creditAccountAmts, *addBtns;
@property (nonatomic) UIPopoverController *datePopover, *typePopover, *debitPopover, *creditPopover;
@property (nonatomic) NSString *selectedType;
@property (nonatomic, assign) BOOL multiple;

- (BOOL) validate;
@end

@implementation TransactionVC

- (void) viewDidLoad {
	[super viewDidLoad];
	
	NSSortDescriptor *ascendingSort = [[NSSortDescriptor alloc] initWithKey:@"tag" ascending:YES];
	self.debitAccounts = [self.debitAccTxts sortedArrayUsingDescriptors:@[ascendingSort]];
	self.creditAccounts = [self.creditAccTxts sortedArrayUsingDescriptors:@[ascendingSort]];
	self.debitAccountAmts = [self.debitAccAmts sortedArrayUsingDescriptors:@[ascendingSort]];
	self.creditAccountAmts = [self.creditAccAmts sortedArrayUsingDescriptors:@[ascendingSort]];
	self.addBtns = [self.addNewBtns sortedArrayUsingDescriptors:@[ascendingSort]];

	for (int i = 1; i < 5; i++) {
		((UITextField *)self.debitAccounts[i]).hidden = YES;
		((UITextField *)self.creditAccounts[i]).hidden = YES;
		((UITextField *)self.debitAccountAmts[i]).hidden = YES;
		((UITextField *)self.creditAccountAmts[i]).hidden = YES;

		if (i < 4) {
			((UIButton *)self.addBtns[i]).hidden = YES;
		}
	}
	((UITextField *)self.debitAccountAmts[0]).hidden = YES;
	self.firstAmtLbl.hidden = YES;
	self.multiple = NO;
	[self.dateBtn setTitle:[Utils getStringFrom:[NSDate date]] forState:UIControlStateNormal];

	self.dateBtn.layer.borderColor = [UIColor blackColor].CGColor;
	self.dateBtn.layer.borderWidth = 1.0f;
	self.typeBtn.layer.borderColor = [UIColor blackColor].CGColor;
	self.typeBtn.layer.borderWidth = 1.0f;
}

- (IBAction) showNextRow:(id)sender {
	((UITextField *)self.debitAccounts[[sender tag]+1]).hidden = NO;
	((UITextField *)self.creditAccounts[[sender tag]+1]).hidden = NO;
	((UITextField *)self.debitAccountAmts[[sender tag]+1]).hidden = NO;
	((UITextField *)self.creditAccountAmts[[sender tag]+1]).hidden = NO;

	((UIButton *)self.addBtns[[sender tag]]).hidden = YES;

	if ([sender tag] < 3) {
		((UIButton *)self.addBtns[[sender tag]+1]).hidden = NO;
	}

	((UITextField *)self.debitAccountAmts[0]).hidden = NO;
	self.firstAmtLbl.hidden = NO;
	self.multiple = YES;
}

- (void) popoverSelected:(id)object source:(UIControl *)src {
	if ([object isKindOfClass:[NSDate class]]) {
		[self.dateBtn setTitle:[Utils getStringFrom:object] forState:UIControlStateNormal];
		[self.datePopover dismissPopoverAnimated:YES];
		self.datePopover = nil;
	}
	else if ([object isKindOfClass:[NSString class]]) {
		[self.typeBtn setTitle:object forState:UIControlStateNormal];
		self.selectedType = object;
		[self.typePopover dismissPopoverAnimated:YES];
		self.typePopover = nil;

		self.debitLbl.text = DEBITLBLS[[TYPES indexOfObject:object]];
		self.creditLbl.text = CRDITLBLS[[TYPES indexOfObject:object]];
		self.tarifLbl.text = HELPTXTS[[TYPES indexOfObject:object]];
		self.descTxt.text = @"";

		for (int i = 0; i < 5; i++) {
			((UITextField *)self.debitAccounts[i]).text = @"";
			((UITextField *)self.debitAccountAmts[i]).text = @"";
			((UITextField *)self.creditAccounts[i]).text = @"";
			((UITextField *)self.creditAccountAmts[i]).text = @"";
		}
	}
	else if ([object isKindOfClass:[NSManagedObject class]]) {
		Account *account = object;
		((UITextField*)src).text = account.name;

		if (self.debitPopover && self.debitPopover.isPopoverVisible) {
			[self.debitPopover dismissPopoverAnimated:YES];
			self.debitPopover = nil;
		}
		else if (self.creditPopover && self.creditPopover.isPopoverVisible) {
			[self.creditPopover dismissPopoverAnimated:YES];
			self.creditPopover = nil;
		}
	}
}

- (IBAction) close:(id)sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL) validate {
    if (!self.selectedType) {
        [Utils showMessage:@"Lütfen işlem türünü seçin!" target:nil];
        return NO;
    }
    
    if ([Utils isEmpty:self.debitAccounts[0]] || [Utils isEmpty:self.creditAccounts[0]]) {
        [Utils showMessage:@"Lütfen hesapları seçin!" target:nil];
        return NO;
    }
    
    if ([Utils isEmpty:self.creditAccountAmts[0]]) {
        [Utils showMessage:@"Tutar girmeniz gerekiyor!" target:nil];
        return NO;
    }
    
    BOOL inconsistency = NO;
    for (int i = 1; i < 5; i++) {
        if ([Utils isEmpty:self.debitAccounts[i]] != [Utils isEmpty:self.debitAccountAmts[i]]) {
            inconsistency = YES;
            break;
        }
        if ([Utils isEmpty:self.creditAccounts[i]] != [Utils isEmpty:self.creditAccountAmts[i]]) {
            inconsistency = YES;
            break;
        }
    }
    
    if (inconsistency) {
        [Utils showMessage:@"Hesap-Tutar dengesizliği var!" target:nil];
        return NO;
    }
    
    BOOL wrongFormat = NO;
    for (int i = 0; i < 5; i++) {
        if (![Utils isEmpty:self.debitAccounts[i]]) {
            if (i > 0 && ![Utils validateAmount:((UITextField*)self.debitAccountAmts[i]).text]) {
                wrongFormat = YES;
                break;
            }
        }
        if (![Utils isEmpty:self.creditAccounts[i]]) {
            if (![Utils validateAmount:((UITextField*)self.creditAccountAmts[i]).text]) {
                wrongFormat = YES;
                break;
            }
        }
    }
    if (wrongFormat) {
        [Utils showMessage:@"Tutar(lar) geçerli formatta değil!" target:nil];
        return NO;
    }

    if (self.multiple) {
        double debitSum = 0, creditSum = 0;
        
        for (int i = 0; i < 5; i++) {
            if (![Utils isEmpty:self.debitAccounts[i]]) {
                debitSum += [Utils formatString:((UITextField*)self.debitAccountAmts[i]).text].doubleValue;
            }
            if (![Utils isEmpty:self.creditAccounts[i]]) {
                creditSum += [Utils formatString:((UITextField*)self.creditAccountAmts[i]).text].doubleValue;
            }
        }
        
        if (debitSum != creditSum) {
            [Utils showMessage:[NSString stringWithFormat:@"Tutar toplamları eşit değil\n\n%@ != %@",
                                [NSString stringWithFormat:@"%.02f", debitSum], [NSString stringWithFormat:@"%.02f", creditSum]]
                        target:nil];
            return NO;
        }
    }
    else {
        ((UITextField *)self.debitAccountAmts[0]).text = ((UITextField *)self.creditAccountAmts[0]).text;
    }
    
    return YES;
}

- (IBAction) save:(id)sender {

    if (![self validate])
        return;

	NSManagedObjectContext *ctx = [Utils getContext];

	NSNumber *nextId = [TxUtils getNextTransactionId];
	Transaction *transaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction"
															 inManagedObjectContext:ctx];
	NSString *desc = [Utils isEmpty:self.descTxt] ? @"" : [[Utils trim:self.descTxt.text] uppercaseString];
	// Remove ; for csv parsing
	transaction.desc = [desc stringByReplacingOccurrencesOfString:@";" withString:@":"];
	transaction.date = [Utils getDateFrom:self.dateBtn.titleLabel.text];
	transaction.tid = nextId;

	NSMutableSet *transactionItems = [[NSMutableSet alloc] init];

	for (int i = 0; i < 5; i++) {
		if (![Utils isEmpty:self.debitAccounts[i]]) {
			TransactionItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"TransactionItem"
																  inManagedObjectContext:ctx];

			Account *account = [AccountUtils fetchManagedAccountWithName:((UITextField *) self.debitAccounts[i]).text];
			item.relAccount = account;
			item.isDebit = @(YES);
			item.invrelItems = transaction;
			
			NSMutableSet *set = [account.invrelAccount mutableCopy];
			[set addObject:item];
			account.invrelAccount = set;
            
            if ([Utils isEmpty:self.debitAccountAmts[i]] && i == 0) {
                item.amount = [Utils formatString:((UITextField *)self.creditAccountAmts[0]).text];
            }
            else {
                item.amount = [Utils formatString:((UITextField *)self.debitAccountAmts[i]).text];
            }

            [transactionItems addObject:item];

			// Update account balance
			double currentBalance = account.balance.doubleValue;

			if ([account.subtype isEqual:@(AccountSubtypeAsset)] ||
				[account.subtype isEqual:@(AccountSubtypeDual)] ||
				[account.subtype isEqual:@(AccountSubtypeExpense)]) {
				currentBalance += item.amount.doubleValue;
			}
			else {
				currentBalance -= item.amount.doubleValue;
			}
			account.balance = [Utils formatString:[NSString stringWithFormat:@"%f", currentBalance]];

            // Update current year
            if ([account.subtype isEqual:@(AccountSubtypeIncome)] || [account.subtype isEqual:@(AccountSubtypeExpense)]) {
                Account *curYearAccount = [AccountUtils fetchManagedAccountWithName:currentYear];
                double curYearAccountBalance = curYearAccount.balance.doubleValue;
                curYearAccountBalance -= item.amount.doubleValue;
                curYearAccount.balance = [Utils formatString:[NSString stringWithFormat:@"%f", curYearAccountBalance]];
            }
		}

        if (![Utils isEmpty:self.creditAccounts[i]]) {
            TransactionItem *item = (TransactionItem *) [NSEntityDescription insertNewObjectForEntityForName:@"TransactionItem"
                                                                  inManagedObjectContext:ctx];

			Account *account = [AccountUtils fetchManagedAccountWithName:((UITextField *) self.creditAccounts[i]).text];
            item.relAccount = account;
            item.isDebit = @(NO);
            item.invrelItems = transaction;
            item.amount = [Utils formatString:((UITextField *)self.creditAccountAmts[i]).text];

			NSMutableSet *set = [account.invrelAccount mutableCopy];
			[set addObject:item];
			account.invrelAccount = set;

            [transactionItems addObject:item];
			
			// Update account balance
			double currentBalance = account.balance.doubleValue;
			
			if ([account.subtype isEqual:@(AccountSubtypeLiability)] ||
				[account.subtype isEqual:@(AccountSubtypeIncome)]) {
				currentBalance += item.amount.doubleValue;
			}
			else {
				currentBalance -= item.amount.doubleValue;
			}
			account.balance = [Utils formatString:[NSString stringWithFormat:@"%f", currentBalance]];
            
            // Update current year
            if ([account.subtype isEqual:@(AccountSubtypeIncome)] || [account.subtype isEqual:@(AccountSubtypeExpense)]) {
                Account *curYearAccount = [AccountUtils fetchManagedAccountWithName:currentYear];
                double curYearAccountBalance = curYearAccount.balance.doubleValue;
                curYearAccountBalance += item.amount.doubleValue;
                curYearAccount.balance = [Utils formatString:[NSString stringWithFormat:@"%f", curYearAccountBalance]];
            }
        }
	}
    
    transaction.relItems = transactionItems;
    
    // Save
    NSError *error;
    if (![ctx save:&error]) {
        [Utils showMessage:[NSString stringWithFormat:@"Bir hata oluştu:\n\n%@",[error localizedDescription]]
                    target:nil];
    }
    else {
        [Utils showMessage:@"İşlem başarıyla kaydedildi!" target:nil];

		// Reset
		[self.typeBtn setTitle:@"Seçin" forState:UIControlStateNormal];
        self.selectedType = nil;
		self.tarifLbl.text = @"";
		self.descTxt.text = @"";
		for (int i = 0; i < 5; i++) {
			((UITextField *)self.debitAccounts[i]).text = @"";
			((UITextField *)self.debitAccountAmts[i]).text = @"";
			((UITextField *)self.creditAccounts[i]).text = @"";
			((UITextField *)self.creditAccountAmts[i]).text = @"";
		}
		
		[[NSNotificationCenter defaultCenter] postNotificationName:reloadNotification object:nil];
    }
}

- (IBAction) showDatePopover:(id)sender {
	NSDate *today = [NSDate date];
	NSArray *popArray = @[[today dateByAddingTimeInterval: -86400.0*4],
						  [today dateByAddingTimeInterval: -86400.0*3],
						  [today dateByAddingTimeInterval: -86400.0*2],
						  [today dateByAddingTimeInterval: -86400.0],
						  today];
	
	if (self.datePopover && self.datePopover.popoverVisible) {
		[self.datePopover dismissPopoverAnimated:YES];
		self.datePopover = nil;
	}
	else {
		if (self.datePopover == nil) {
			PopoverTableVC *popoverTable = [[PopoverTableVC alloc] initWithArray:popArray
																		delegate:self
																		   width:132];
			self.datePopover = [[UIPopoverController alloc] initWithContentViewController:popoverTable];
		}

		[self.datePopover presentPopoverFromRect:self.dateBtn.frame
										  inView:self.view
						permittedArrowDirections:UIPopoverArrowDirectionUp
										animated:YES];
		self.datePopover.passthroughViews = nil;
	}
}

- (IBAction) showTypePopover:(id)sender {
	if (self.typePopover && self.typePopover.popoverVisible) {
		[self.typePopover dismissPopoverAnimated:YES];
		self.typePopover = nil;
	}
	else {
		if (self.typePopover == nil) {
			PopoverTableVC *popoverTable = [[PopoverTableVC alloc] initWithArray:TYPES
																		delegate:self
																		   width:245];
			self.typePopover = [[UIPopoverController alloc] initWithContentViewController:popoverTable];
		}
		
		[self.typePopover presentPopoverFromRect:self.typeBtn.frame
										  inView:self.view
						permittedArrowDirections:UIPopoverArrowDirectionUp
										animated:YES];
		self.typePopover.passthroughViews = nil;
	}

}

@end

@implementation TransactionVC (TextFieldDelegate)
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {

	if (textField == self.descTxt || [self.debitAccountAmts containsObject:textField] || [self.creditAccountAmts containsObject:textField]) {
		return YES;
	}

	if ([self.debitAccounts containsObject:textField]) {
		if (!self.selectedType) {
			return NO;
		}

		NSPredicate *predicate = nil;
		if ([self.selectedType isEqual:TYPES[0]]) {
			predicate = [NSPredicate predicateWithFormat:@"group = %@ OR subtype = %@", @(AccountGroupCurrentAsset), @(AccountSubtypeDual)];
		}
        else if ([self.selectedType isEqual:TYPES[1]]) {
            predicate = [NSPredicate predicateWithFormat:@"subtype = %@", @(AccountSubtypeExpense)];
        }
		else if ([self.selectedType isEqual:TYPES[2]]) {
			predicate = [NSPredicate predicateWithFormat:@"subtype = %@", @(AccountSubtypeAsset)];
		}
		else if ([self.selectedType isEqual:TYPES[3]]) {
			predicate = [NSPredicate predicateWithFormat:@"group = %@ || group = %@",
						 @(AccountGroupCurrentAsset), @(AccountGroupShortTerm)];
		}
		else if ([self.selectedType isEqual:TYPES[4]]) {
			predicate = [NSPredicate predicateWithFormat:@"group = %@ OR subtype = %@",
						 @(AccountGroupCurrentAsset), @(AccountSubtypeDual)];
		}
		else if ([self.selectedType isEqual:TYPES[5]]) {
			predicate = [NSPredicate predicateWithFormat:@"subtype = %@", @(AccountSubtypeLiability)];
		}
		else if ([self.selectedType isEqual:TYPES[6]]) {
			predicate = [NSPredicate predicateWithFormat:@"subtype = %@", @(AccountSubtypeAsset)];
		}
		else if ([self.selectedType isEqual:TYPES[7]]) {
			predicate = [NSPredicate predicateWithFormat:@"group = %@", @(AccountGroupCurrentAsset)];
		}
		else if ([self.selectedType isEqual:TYPES[8]]) {
			predicate = [NSPredicate predicateWithFormat:@"isActive = %@ AND group != %@", @(YES), @(AccountGroupCapital)];
		}

		NSArray *popArray = [AccountUtils fetchAccountsWithPredicate:predicate];

		if (self.debitPopover && self.debitPopover.popoverVisible) {
			[self.debitPopover dismissPopoverAnimated:YES];
			self.debitPopover = nil;
		}
		else {
			PopoverTableVC *popoverTable = [[PopoverTableVC alloc] initWithArray:popArray
																		delegate:self
																		   width:260];
			popoverTable.popoverSource = textField;
			self.debitPopover = [[UIPopoverController alloc] initWithContentViewController:popoverTable];
			
			[self.debitPopover presentPopoverFromRect:textField.frame
											   inView:self.view
							 permittedArrowDirections:UIPopoverArrowDirectionUp
											 animated:YES];
			self.debitPopover.passthroughViews = nil;
		}

	}
	else if ([self.creditAccounts containsObject:textField]) {
		if (!self.selectedType) {
			return NO;
		}

		NSPredicate *predicate = nil;
		if ([self.selectedType isEqual:TYPES[0]]) {
			predicate = [NSPredicate predicateWithFormat:@"subtype = %@", @(AccountSubtypeIncome)];
		}
        else if ([self.selectedType isEqual:TYPES[1]]) {
            predicate = [NSPredicate predicateWithFormat:@"group = %@ OR group = %@ OR subtype = %@",
                         @(AccountGroupCurrentAsset), @(AccountGroupShortTerm), @(AccountSubtypeDual)];
        }
		else if ([self.selectedType isEqual:TYPES[2]]) {
			predicate = [NSPredicate predicateWithFormat:@"group = %@ OR subtype = %@ OR subtype = %@", @(AccountGroupCurrentAsset), @(AccountSubtypeDual), @(AccountSubtypeLiability)];
		}
		else if ([self.selectedType isEqual:TYPES[3]]) {
			predicate = [NSPredicate predicateWithFormat:@"subtype = %@", @(AccountSubtypeAsset)];
		}
		else if ([self.selectedType isEqual:TYPES[4]]) {
			predicate = [NSPredicate predicateWithFormat:@"subtype = %@", @(AccountSubtypeLiability)];
		}
		else if ([self.selectedType isEqual:TYPES[5]]) {
			predicate = [NSPredicate predicateWithFormat:@"subtype = %@ OR subtype = %@",
						 @(AccountSubtypeAsset), @(AccountSubtypeDual)];
		}
		else if ([self.selectedType isEqual:TYPES[6]]) {
			predicate = [NSPredicate predicateWithFormat:@"group = %@ OR group = %@ OR subtype = %@",
						 @(AccountGroupCurrentAsset), @(AccountGroupShortTerm), @(AccountSubtypeDual)];
		}
		else if ([self.selectedType isEqual:TYPES[7]]) {
			predicate = [NSPredicate predicateWithFormat:@"subtype = %@ OR subtype = %@",
						 @(AccountSubtypeAsset), @(AccountSubtypeDual)];
		}
		else if ([self.selectedType isEqual:TYPES[8]]) {
			predicate = [NSPredicate predicateWithFormat:@"isActive = %@ AND group != %@", @(YES), @(AccountGroupCapital)];
		}

		NSArray *popArray = [AccountUtils fetchAccountsWithPredicate:predicate];

		if (self.creditPopover && self.creditPopover.popoverVisible) {
			[self.creditPopover dismissPopoverAnimated:YES];
			self.creditPopover = nil;
		}
		else {
			PopoverTableVC *popoverTable = [[PopoverTableVC alloc] initWithArray:popArray
																		delegate:self
																		   width:260];
			popoverTable.popoverSource = textField;
			self.creditPopover = [[UIPopoverController alloc] initWithContentViewController:popoverTable];
			
			[self.creditPopover presentPopoverFromRect:textField.frame
												inView:self.view
							  permittedArrowDirections:UIPopoverArrowDirectionUp
											  animated:YES];
			self.creditPopover.passthroughViews = nil;
		}
	}

	return NO;
}

@end
