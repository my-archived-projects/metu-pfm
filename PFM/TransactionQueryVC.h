//
//  TransactionQueryVC.h
//  PFM
//
//  Created by Metehan Karabiber on 28/03/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

@interface TransactionQueryVC : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextField *keyword;
@property (nonatomic, weak) IBOutlet UILabel *noTxLbl;

- (IBAction) close:(id)sender;
- (IBAction) query:(id)sender;

@end
