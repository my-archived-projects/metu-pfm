//
//  PieChartViewController.h
//  PFM
//
//  Created by Metehan Karabiber on 4/3/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

@class XYPieChart;

@interface PieChartViewController : UIViewController
@property (nonatomic, weak) IBOutlet XYPieChart *pieChartIncome, *pieChartExpense;

- (IBAction) close:(id)sender;

@end
