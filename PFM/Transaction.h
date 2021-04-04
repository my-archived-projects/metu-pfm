//
//  Transaction.h
//  PFM
//
//  Created by Metehan Karabiber on 4/8/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

@import CoreData;

@class TransactionItem;

@interface Transaction : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * tid;
@property (nonatomic, retain) NSSet *relItems;
@end
