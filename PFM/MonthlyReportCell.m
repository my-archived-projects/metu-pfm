//
//  MonthlyReportCell.m
//  PFM
//
//  Created by Metehan Karabiber on 03/04/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "MonthlyReportCell.h"

@implementation MonthlyReportCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    self.backgroundView = nil;
    self.contentView.backgroundColor = [UIColor whiteColor];

    self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 350, 44)];
    self.nameLbl.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.nameLbl];

    self.month1Lbl = [[UILabel alloc] initWithFrame:CGRectMake(374, 0, 120, 44)];
    self.month1Lbl.font = [UIFont systemFontOfSize:17];
    self.month1Lbl.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.month1Lbl];

    self.month2Lbl = [[UILabel alloc] initWithFrame:CGRectMake(502, 0, 120, 44)];
    self.month2Lbl.font = [UIFont systemFontOfSize:17];
    self.month2Lbl.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.month2Lbl];

    self.month3Lbl = [[UILabel alloc] initWithFrame:CGRectMake(630, 0, 120, 44)];
    self.month3Lbl.font = [UIFont systemFontOfSize:17];
    self.month3Lbl.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.month3Lbl];

    return self;
}

@end
