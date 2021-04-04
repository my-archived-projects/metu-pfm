//
//  TxUtils.h
//  PFM
//
//  Created by Metehan Karabiber on 27/03/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

@import Foundation;
@import CoreData;

@class Transaction;

@interface TxUtils : NSObject

+ (NSArray *) fetchTransactions;
+ (Transaction *) fetchTransaction:(NSManagedObjectID *)txId;
+ (NSArray *) fetchTransactionsWithPredicate:(NSPredicate *)predicate;
+ (NSArray *) fetchTransactionItemsWithPredicate:(NSPredicate *)predicate;
+ (NSNumber *) getNextTransactionId;

@end
