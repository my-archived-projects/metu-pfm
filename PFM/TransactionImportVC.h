//
//  TransactionImportVC.h
//  PFM
//
//  Created by Metehan Karabiber on 4/5/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

@interface TransactionImportVC : UIViewController
@property(nonatomic) NSArray *transactions;
@end

@interface Tx : NSObject
@property (nonatomic, copy) NSString *date, *debitAmt, *creditAmt, *desc;
@end
