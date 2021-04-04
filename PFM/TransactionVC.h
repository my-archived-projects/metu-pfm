//
//  TransactionVC.h
//  PFM
//
//  Created by Metehan Karabiber on 3/21/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "PopoverTableDelegate.h"

@interface TransactionVC : UIViewController <PopoverTableDelegate>

@property (nonatomic) IBOutletCollection(UITextField) NSArray *debitAccTxts, *creditAccTxts;
@property (nonatomic) IBOutletCollection(UITextField) NSArray *debitAccAmts, *creditAccAmts;
@property (nonatomic) IBOutletCollection(UIButton) NSArray *addNewBtns;

@property (nonatomic, weak) IBOutlet UIButton *dateBtn, *typeBtn;
@property (nonatomic, weak) IBOutlet UITextField *descTxt;
@property (nonatomic, weak) IBOutlet UILabel *tarifLbl, *firstAmtLbl, *debitLbl, *creditLbl;

- (IBAction) showNextRow:(id)sender;
- (IBAction) showDatePopover:(id)sender;
- (IBAction) showTypePopover:(id)sender;

- (IBAction) close:(id)sender;
- (IBAction) save:(id)sender;

@end
