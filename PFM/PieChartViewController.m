//
//  PieChartViewController.m
//  PFM
//
//  Created by Metehan Karabiber on 4/3/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

@import QuartzCore;

#import "PieChartViewController.h"
#import "XYPieChart.h"
#import "AccountUtils.h"
#import "Account.h"

@interface PieChartViewController () <XYPieChartDelegate, XYPieChartDataSource>

@property (nonatomic) NSArray *incomeAccounts, *expenseAccounts;
@property (nonatomic) NSArray *sliceColors;
@end

@implementation PieChartViewController

- (void) viewDidLoad {
	[super viewDidLoad];

	self.pieChartIncome.dataSource = self;
	self.pieChartIncome.delegate = self;
	[self.pieChartIncome setStartPieAngle:M_PI_2];
	[self.pieChartIncome setAnimationSpeed:1.0];
	[self.pieChartIncome setLabelFont:[UIFont systemFontOfSize:20.0f]];
	[self.pieChartIncome setLabelRadius:160];
	[self.pieChartIncome setShowPercentage:NO];
	[self.pieChartIncome setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
	[self.pieChartIncome setPieCenter:CGPointMake(220, 220)];
	[self.pieChartIncome setUserInteractionEnabled:NO];
	[self.pieChartIncome setLabelShadowColor:[UIColor blackColor]];
	
	[self.pieChartExpense setDataSource:self];
	[self.pieChartExpense setStartPieAngle:M_PI_2];
	[self.pieChartExpense setAnimationSpeed:1.0];
	[self.pieChartExpense setLabelFont:[UIFont systemFontOfSize:20.0f]];
	[self.pieChartExpense setLabelRadius:160];
	[self.pieChartExpense setShowPercentage:NO];
	[self.pieChartExpense setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
	[self.pieChartExpense setPieCenter:CGPointMake(220, 220)];
	[self.pieChartExpense setUserInteractionEnabled:NO];
	[self.pieChartExpense setLabelShadowColor:[UIColor blackColor]];
	
	self.sliceColors = [NSArray arrayWithObjects:
					   [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
					   [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
					   [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
					   [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
					   [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
	
	self.incomeAccounts = [AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"subtype = %@",
																	@(AccountSubtypeIncome)]];
	self.expenseAccounts = [AccountUtils fetchAccountsWithPredicate:[NSPredicate predicateWithFormat:@"subtype = %@",
																	 @(AccountSubtypeExpense)]];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	[self.pieChartIncome reloadData];
	[self.pieChartExpense reloadData];
}

- (IBAction) close:(id)sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSUInteger) numberOfSlicesInPieChart:(XYPieChart *)pieChart {
	return (pieChart == self.pieChartIncome) ? self.incomeAccounts.count : self.expenseAccounts.count;
}

- (CGFloat) pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
	return (pieChart == self.pieChartIncome) ?
			((Account *)self.incomeAccounts[index]).balance.floatValue :
			((Account *)self.expenseAccounts[index]).balance.floatValue;
}

- (UIColor *) pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
	return self.sliceColors[index % self.sliceColors.count];
}

- (NSString *) pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index {
	Account *account = (pieChart == self.pieChartIncome) ? self.incomeAccounts[index] : self.expenseAccounts[index];
	return [NSString stringWithFormat:@"%@\n%@", account.name, [[Utils numberFormatter] stringFromNumber:account.balance]];
}

@end


