//
//  AccountStatementVC.h
//  PFM
//
//  Created by Metehan Karabiber on 28/03/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "PopoverTableDelegate.h"

@interface AccountStatementVC : UIViewController <PopoverTableDelegate>
@property (nonatomic, weak) IBOutlet UITableView *statementTable;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *accountBtn;
@property (nonatomic, weak) IBOutlet UIButton *monthBtn;

- (IBAction) showAccountPopover:(id)sender;
- (IBAction) showMonthPopover:(id)sender;
- (IBAction) close:(id)sender;

@end
