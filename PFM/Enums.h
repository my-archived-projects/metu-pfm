//
//  Enums.h
//  PFM
//
//  Created by Metehan Karabiber on 4/8/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, AccountType) {
	AccountTypeBalanceSheet,
	AccountTypeIncomeTable
};

typedef NS_ENUM(NSInteger, AccountSubtype) {
	AccountSubtypeAsset,
	AccountSubtypeLiability,
	AccountSubtypeDual,
	AccountSubtypeIncome,
	AccountSubtypeExpense
};

typedef NS_ENUM(NSInteger, AccountGroup) {
	AccountGroupShortTerm,
	AccountGroupLongTerm,
	AccountGroupCurrentAsset,
	AccountGroupFixedAsset,
	AccountGroupCapital
};
