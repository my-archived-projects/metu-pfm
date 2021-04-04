//
//  BankAccountCell.m
//  PFM
//
//  Created by Metehan Karabiber on 4/10/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "BankAccountCell.h"
@import QuartzCore;

@implementation BankAccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
	self.backgroundView = nil;
	self.contentView.backgroundColor = [UIColor whiteColor];

	self.dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 82, 44)];
	self.dateLbl.textAlignment = NSTextAlignmentCenter;
	self.dateLbl.font = [UIFont systemFontOfSize:16];
	self.dateLbl.textColor = [UIColor blackColor];
	[self.contentView addSubview:self.dateLbl];

	self.debitAmtLbl = [[UILabel alloc] initWithFrame:CGRectMake(98, 0, 100, 44)];
	self.debitAmtLbl.textAlignment = NSTextAlignmentRight;
	self.debitAmtLbl.font = [UIFont systemFontOfSize:16];
	self.debitAmtLbl.textColor = [UIColor blackColor];
	[self.contentView addSubview:self.debitAmtLbl];

	self.creditAmtLbl = [[UILabel alloc] initWithFrame:CGRectMake(206, 0, 100, 44)];
	self.creditAmtLbl.textAlignment = NSTextAlignmentRight;
	self.creditAmtLbl.font = [UIFont systemFontOfSize:16];
	self.creditAmtLbl.textColor = [UIColor blackColor];
	[self.contentView addSubview:self.creditAmtLbl];

	self.againstAcc = [[UIButton alloc] initWithFrame:CGRectMake(314, 0, 200, 44)];
	self.againstAcc.titleLabel.font = [UIFont systemFontOfSize:16];
	[self.againstAcc setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.againstAcc setTitle:@"Seçin" forState:UIControlStateNormal];
	[self.contentView addSubview:self.againstAcc];

	self.descTxt = [[UITextField alloc] initWithFrame:CGRectMake(522, 8, 222, 28)];
	self.descTxt.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
	self.descTxt.layer.borderWidth = 1;
	self.descTxt.textAlignment = NSTextAlignmentLeft;
	self.descTxt.font = [UIFont systemFontOfSize:16];
	self.descTxt.textColor = [UIColor blackColor];
	[self.contentView addSubview:self.descTxt];

	return self;
}

@end
