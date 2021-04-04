//
//  AccountUtils.m
//  PFM
//
//  Created by Metehan Karabiber on 3/14/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

@import CoreData;

#import "AccountUtils.h"
#import "Account.h"

@implementation AccountUtils

+ (NSArray *) fetchAccounts {
	return [AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"isActive = %@ AND group != %@", @(YES), @(AccountGroupCapital)]];
}

+ (NSArray *) fetchAccountsWithInactive {
    return [AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"group != %@", @(AccountGroupCapital)]];
}

+ (Account *) fetchManagedAccountWithName:(NSString *)accountName {
    NSArray *results = [AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"name = %@", accountName]];

    if (results && results.count > 0) {
        return results[0];
    }

	return nil;
}

+ (NSArray *) fetchAccountsWithPredicate:(NSPredicate *)predicate {
	NSManagedObjectContext *ctx = [Utils getContext];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account"
											  inManagedObjectContext:ctx];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entity];
	[fetchRequest setPredicate:predicate];
	
	return [ctx executeFetchRequest:fetchRequest error:NULL];;
}

@end
