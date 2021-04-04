//
//  TQTableViewCell.m
//  PFM
//
//  Created by Metehan Karabiber on 4/1/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "TQTableViewCell.h"

@implementation TQTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
	self.backgroundView = nil;
	self.contentView.backgroundColor = [UIColor whiteColor];
    self.accessoryType = UITableViewCellAccessoryDetailButton;
	
	self.referenceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 56, 44)];
	self.referenceLbl.textAlignment = NSTextAlignmentCenter;
	self.referenceLbl.font = [UIFont systemFontOfSize:16];
	self.referenceLbl.textColor = [UIColor blackColor];
	[self.contentView addSubview:self.referenceLbl];
	
	self.dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(56, 0, 82, 44)];
	self.dateLbl.textAlignment = NSTextAlignmentCenter;
	self.dateLbl.font = [UIFont systemFontOfSize:16];
	self.dateLbl.textColor = [UIColor blackColor];
	[self.contentView addSubview:self.dateLbl];
	
	self.amountLbl = [[UILabel alloc] initWithFrame:CGRectMake(138, 0, 100, 44)];
	self.amountLbl.textAlignment = NSTextAlignmentRight;
	self.amountLbl.font = [UIFont systemFontOfSize:16];
	self.amountLbl.textColor = [UIColor blackColor];
	[self.contentView addSubview:self.amountLbl];
	
	self.descLbl = [[UILabel alloc] initWithFrame:CGRectMake(248, 0, 200, 44)];
	self.descLbl.textAlignment = NSTextAlignmentLeft;
	self.descLbl.font = [UIFont systemFontOfSize:16];
	self.descLbl.textColor = [UIColor blackColor];
	[self.contentView addSubview:self.descLbl];
	
	return self;
}

@end
