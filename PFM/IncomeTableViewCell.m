//
//  IncomeTableViewCell.m
//  PFM
//
//  Created by Metehan Karabiber on 3/29/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "IncomeTableViewCell.h"

@implementation IncomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

	self.backgroundView = nil;
	self.contentView.backgroundColor = [UIColor whiteColor];

	self.accountName = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 300, 44)];
	self.accountName.textAlignment = NSTextAlignmentLeft;
	self.accountName.font = [UIFont systemFontOfSize:17];
	self.accountName.textColor = [UIColor blackColor];
	[self.contentView addSubview:self.accountName];

	self.accountBalance = [[UILabel alloc] initWithFrame:CGRectMake(320, 0, 200, 44)];
	self.accountBalance.textAlignment = NSTextAlignmentRight;
	self.accountBalance.font = [UIFont systemFontOfSize:17];
	self.accountBalance.textColor = [UIColor blackColor];
	[self.contentView addSubview:self.accountBalance];

	return self;
}

@end
