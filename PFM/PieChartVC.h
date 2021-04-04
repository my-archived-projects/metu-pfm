//
//  PieChartVC.h
//  PFM
//
//  Created by Metehan Karabiber on 03/04/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYPieChart;

@interface PieChartVC : UIViewController

@property (nonatomic, weak) IBOutlet XYPieChart *incomePieChart;
@property (nonatomic, weak) IBOutlet XYPieChart *expensePieChart;

@end
