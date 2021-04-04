//
//  Account.h
//  PFM
//
//  Created by Metehan Karabiber on 4/8/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

@import CoreData;

@class TransactionItem;

@interface Account : NSManagedObject

@property (nonatomic, retain) NSNumber * balance;
@property (nonatomic, retain) NSNumber * group;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * subtype;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSSet *invrelAccount;
@end
