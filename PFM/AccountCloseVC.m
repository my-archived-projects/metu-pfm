//
//  AccountCloseVC.m
//  PFM
//
//  Created by Metehan Karabiber on 3/15/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "AccountCloseVC.h"
#import "AccountUtils.h"
#import "Account.h"

@interface AccountCloseVC ()
@property (nonatomic) NSArray *accounts;
@property (nonatomic) Account *selectedAccount;

- (void) loadAccounts;
@end

@implementation AccountCloseVC

- (void)viewDidLoad {
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

- (IBAction) close:(id)sender {
	
	if (self.selectedAccount.balance.doubleValue > 0) {
		[Utils showMessage:@"Hesapta bakiye mevcut!" target:nil];
		return;
	}

	[[[UIAlertView alloc] initWithTitle:@"Uyarı"
								message:@"Emin misiniz?"
							   delegate:self
					  cancelButtonTitle:nil
					  otherButtonTitles:@"Hayir", @"Evet", nil] show];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		Account *accountToClose = [AccountUtils fetchManagedAccountWithName:self.selectedAccount.name];
        accountToClose.isActive = @NO;
		
		[[Utils getContext] save:NULL];
		[Utils showMessage:@"Hesap kapatıldı!" target:nil];

		[self loadAccounts];
		[self.pickerView reloadAllComponents];
		[[NSNotificationCenter defaultCenter] postNotificationName:reloadNotification object:nil];
	}
}


- (IBAction) cancel:(id)sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}


@end
