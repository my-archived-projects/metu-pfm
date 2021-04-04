//
//  AccountCloseVC.h
//  PFM
//
//  Created by Metehan Karabiber on 3/15/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

@interface AccountCloseVC : UIViewController
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;

- (IBAction) close:(id)sender;
- (IBAction) cancel:(id)sender;

@end
