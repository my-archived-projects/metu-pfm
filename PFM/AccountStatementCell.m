//
//  AccountStatementCell.m
//  PFM
//
//  Created by Metehan Karabiber on 30/03/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "AccountStatementCell.h"

@implementation AccountStatementCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    self.backgroundView = nil;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.accessoryType = UITableViewCellAccessoryDetailButton;

    self.referenceLbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 60, 44)];
    self.referenceLbl.textAlignment = NSTextAlignmentCenter;
    self.referenceLbl.font = [UIFont systemFontOfSize:17];
    self.referenceLbl.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.referenceLbl];

    self.dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(68, 0, 100, 44)];
    self.dateLbl.textAlignment = NSTextAlignmentCenter;
    self.dateLbl.font = [UIFont systemFontOfSize:17];
    self.dateLbl.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.dateLbl];

    self.amountLbl = [[UILabel alloc] initWithFrame:CGRectMake(168, 0, 120, 44)];
    self.amountLbl.textAlignment = NSTextAlignmentRight;
    self.amountLbl.font = [UIFont systemFontOfSize:17];
    self.amountLbl.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.amountLbl];

    self.descLbl = [[UILabel alloc] initWithFrame:CGRectMake(296, 0, 392, 44)];
    self.descLbl.textAlignment = NSTextAlignmentLeft;
    self.descLbl.font = [UIFont systemFontOfSize:17];
    self.descLbl.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.descLbl];


    return self;
}

@end
