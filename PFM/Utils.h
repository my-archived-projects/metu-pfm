//
//  Utils.h
//  PFM
//
//  Created by Metehan Karabiber on 3/15/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import <CoreData/CoreData.h>

static NSString *reloadNotification = @"ReloadNotification";
static NSString *startingcapital = @"ÖZKAYNAK";
static NSString *pastYears = @"GEÇEN YILLAR KÂR/ZARAR";
static NSString *currentYear = @"YILLIK KÂR/ZARAR";
static NSString *digits = @"0123456789,";
static NSString *months[12] = {@"OCAK",@"ŞUBAT",@"MART",@"NİSAN",@"MAYIS",@"HAZİRAN",@"TEMMUZ",@"AĞUSTOS",@"EYLÜL",@"EKİM",@"KASIM",@"ARALIK"};

@interface Utils : NSObject

+ (NSManagedObjectContext *) getContext;

+ (NSString *) getStringFrom:(NSDate *)date;

+ (NSDate *) getDateFrom:(NSString *)str;

+ (long) getNumberOfDays:(NSDate *)date;

+ (NSString *) trim:(NSString *)text;

+ (NSDateFormatter *) dateFormatter;

+ (NSNumberFormatter *) numberFormatter;

+ (NSNumber *) formatString:(NSString *)str;

+ (BOOL) validateAmount:(NSString *)str;

+ (BOOL) isEmpty:(UITextField *)tf;

+ (void) showMessage:(NSString *)message target:(id)delegate;

@end
