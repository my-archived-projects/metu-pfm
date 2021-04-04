//
//  AccountRenameVC.h
//  PFM
//
//  Created by Metehan Karabiber on 3/14/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

@interface AccountRenameVC : UIViewController

@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;
@property (nonatomic, weak) IBOutlet UITextField *accountName;

- (IBAction) save:(id)sender;
- (IBAction) cancel:(id)sender;

@end
