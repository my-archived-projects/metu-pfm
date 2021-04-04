//
//  AccountRenameVC.m
//  PFM
//
//  Created by Metehan Karabiber on 3/14/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "AccountRenameVC.h"
#import "AccountUtils.h"
#import "Account.h"

@interface AccountRenameVC ()
@property (nonatomic) NSArray *accounts;
@property (nonatomic) Account *selectedAccount;

- (void) loadAccounts;
@end

@implementation AccountRenameVC

- (void) viewDidLoad {
    [super viewDidLoad];
	[self loadAccounts];
}

- (void) loadAccounts {
	self.accounts = [AccountUtils fetchAccounts];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return self.accounts.count;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return ((Account *)self.accounts[row]).name;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.selectedAccount = self.accounts[row];
}

- (IBAction) save:(id)sender {
	NSString *name = [Utils trim:self.accountName.text];
	if ([name isEqualToString:@""]) {
		[Utils showMessage:@"Yeni hesap adını boş bırakmayın" target:nil];
		return;
	}

	Account *account = [AccountUtils fetchManagedAccountWithName:name];

	if (account != nil) {
		[Utils showMessage:@"Hesap adı zaten mevcut" target:nil];
		return;
	}

	Account *accountToUpdate = [AccountUtils fetchManagedAccountWithName:self.selectedAccount.name];
    accountToUpdate.name = [name uppercaseString];

	[[Utils getContext] save:NULL];

	[Utils showMessage:@"Hesap adı değiştirildi!" target:nil];
	
	[self loadAccounts];
	[self.pickerView reloadAllComponents];
}

- (IBAction) cancel:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:reloadNotification object:nil];

	[self dismissViewControllerAnimated:YES completion:NULL];
}

@end
