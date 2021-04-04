//
//  AccountCreateVC.h
//  PFM
//
//  Created by Metehan Karabiber on 12/03/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

@interface AccountCreateVC : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *accountName, *accountBalance;
@property (nonatomic, weak) IBOutlet UISegmentedControl *accountType, *accountBSSubtype, *accountITSubtype, *accountGroupActive, *accountGroupPassive;
@property (nonatomic, weak) IBOutlet UILabel *accountSubtypeLbl, *accountGroupLbl, *dualHelp, *accountBalanceLbl, *accountBalanceDescLbl;

- (IBAction) save:(id)sender;
- (IBAction) cancel:(id)sender;

- (IBAction) accountTypeSelected:(id)sender;
- (IBAction) accountSubtypeSelected:(id)sender;

@end
