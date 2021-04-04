//
//  PieChartVC.m
//  PFM
//
//  Created by Metehan Karabiber on 03/04/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "PieChartVC.h"
#import "XYPieChart.h"
#import "PFM-Swift.h"

@interface PieChartVC () <XYPieChartDataSource>
@property (nonatomic) NSArray *incomeAccounts, *expenseAccounts;
@end

@implementation PieChartVC

- (void) viewDidLoad {
    [super viewDidLoad];
    
}

- (NSUInteger) numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    return (pieChart == self.incomePieChart) ? self.incomeAccounts.count : self.expenseAccounts.count;
}

- (CGFloat) pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    return (pieChart == self.incomePieChart) ?
    (CGFloat)((Account *)self.incomeAccounts[index]).balance.floatValue :
    (CGFloat)((Account *)self.expenseAccounts[index]).balance.floatValue;
}

- (UIColor *) pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    return [UIColor greenColor];
}

- (NSString *) pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index {
    return (pieChart == self.incomePieChart) ? ((Account *)self.incomeAccounts[index]).name : ((Account *)self.expenseAccounts[index]).name;
}

@end
