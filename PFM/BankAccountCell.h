//
//  BankAccountCell.h
//  PFM
//
//  Created by Metehan Karabiber on 4/10/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

@interface BankAccountCell : UITableViewCell
@property (nonatomic) UILabel *dateLbl, *debitAmtLbl, *creditAmtLbl;
@property (nonatomic) UITextField *descTxt;
@property (nonatomic) UIButton *againstAcc;
@end
