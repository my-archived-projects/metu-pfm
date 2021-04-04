//
//  TransactionItem.h
//  PFM
//
//  Created by Metehan Karabiber on 4/8/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Account, Transaction;

@interface TransactionItem : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * isDebit;
@property (nonatomic, retain) Transaction *invrelItems;
@property (nonatomic, retain) Account *relAccount;

@end
