//
//  TransactionCancelVC.h
//  PFM
//
//  Created by Metehan Karabiber on 28/03/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

@interface TransactionCancelVC : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *reference;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *noReclabel;

- (IBAction) close:(id)sender;
- (IBAction) query:(id)sender;
- (IBAction) reverse:(id)sender;

@end
