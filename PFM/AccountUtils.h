//
//  AccountUtils.h
//  PFM
//
//  Created by Metehan Karabiber on 3/14/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

@import Foundation;

@class Account;

@interface AccountUtils : NSObject

+ (NSArray *) fetchAccounts;
+ (NSArray *) fetchAccountsWithInactive;
+ (Account *) fetchManagedAccountWithName:(NSString *)accountName;
+ (NSArray *) fetchAccountsWithPredicate:(NSPredicate *)predicate;

@end
