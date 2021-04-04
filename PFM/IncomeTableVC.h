//
//  IncomeTableVC.h
//  PFM
//
//  Created by Metehan Karabiber on 28/03/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

@interface IncomeTableVC : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *header;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (IBAction) close:(id)sender;
- (IBAction) showChart:(id)sender;

@end
