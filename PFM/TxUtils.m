//
//  TxUtils.m
//  PFM
//
//  Created by Metehan Karabiber on 27/03/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "TxUtils.h"

@implementation TxUtils

+ (NSArray *) fetchTransactions {
    return [TxUtils fetchTransactionsWithPredicate:nil];
}

+ (Transaction *) fetchTransaction:(NSManagedObjectID *)txId {
    return (Transaction *) [[Utils getContext] objectWithID:txId];
}

+ (NSArray *) fetchTransactionsWithPredicate:(NSPredicate *)predicate {
    NSManagedObjectContext *ctx = [Utils getContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transaction"
                                              inManagedObjectContext:ctx];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];

    NSSortDescriptor *sortByReference = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortByReference]];

    return [ctx executeFetchRequest:fetchRequest error:NULL];;
}

+ (NSNumber *) getNextTransactionId {
	NSManagedObjectContext *ctx = [Utils getContext];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transaction"
											  inManagedObjectContext:ctx];

	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entity];

	if ([ctx executeFetchRequest:fetchRequest error:NULL].count == 0) {
		return @1;
	}
	
	NSExpression *tidExpression = [NSExpression expressionForKeyPath:@"tid"];
	NSExpression *maxTidExpression = [NSExpression expressionForFunction:@"max:"
															   arguments:@[tidExpression]];
	
	NSExpressionDescription *expressionDesc = [[NSExpressionDescription alloc] init];
	[expressionDesc setName:@"maxTid"];
	[expressionDesc setExpression:maxTidExpression];
	[expressionDesc setExpressionResultType:NSInteger16AttributeType];
	
	[fetchRequest setResultType:NSDictionaryResultType];
	[fetchRequest setPropertiesToFetch:@[expressionDesc]];

	NSArray *objects = [ctx	executeFetchRequest:fetchRequest error:NULL];
	NSNumber *lastId = objects[0][@"maxTid"];

	return @(lastId.intValue + 1);
}

+ (NSArray *) fetchTransactionItemsWithPredicate:(NSPredicate *)predicate {
    NSManagedObjectContext *ctx = [Utils getContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TransactionItem"
                                              inManagedObjectContext:ctx];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortByReference = [[NSSortDescriptor alloc] initWithKey:@"invrelItems.date" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortByReference]];
    
    return [ctx executeFetchRequest:fetchRequest error:NULL];;
}


@end
