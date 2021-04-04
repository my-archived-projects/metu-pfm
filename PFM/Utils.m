//
//  Utils.m
//  PFM
//
//  Created by Metehan Karabiber on 3/15/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "CoreDataContext.h"

@implementation Utils

+ (NSManagedObjectContext *) getContext {
    return [CoreDataContext getContext].managedObjectContext;
}

+ (NSString *) getStringFrom:(NSDate *)date {
	return [[Utils dateFormatter] stringFromDate:date];
}

+ (NSDate *) getDateFrom:(NSString *)str {
	return [[Utils dateFormatter] dateFromString:str];
}

+ (long) getNumberOfDays:(NSDate *)date {
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay
                                              inUnit:NSCalendarUnitMonth
                                             forDate:date].length;
}

+ (NSDateFormatter *) dateFormatter {
    static NSDateFormatter *dateFormatter = nil;

    @synchronized(self) {
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd.MM.yyyy"];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"tr_TR"]];
        }
    }
    return dateFormatter;
}

+ (NSNumberFormatter *) numberFormatter {
    static NSNumberFormatter *numberFormatter = nil;

    @synchronized(self) {
        if (numberFormatter == nil) {
            numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [numberFormatter setGroupingSize:3];
            [numberFormatter setCurrencySymbol:@""];
            [numberFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"tr_TR"]];
            [numberFormatter setMaximumFractionDigits:2];
            [numberFormatter setRoundingMode: NSNumberFormatterRoundDown];
        }
    }

    return numberFormatter;
}

+ (NSNumber *) formatString:(NSString *)str {
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	formatter.maximumFractionDigits = 2;
	formatter.roundingMode = NSNumberFormatterRoundDown;

	if ([formatter numberFromString:[Utils trim:str]] == nil) {
		return [formatter numberFromString:[Utils trim:[str stringByReplacingOccurrencesOfString:@"," withString:@"."]]];
	}

	return [formatter numberFromString:[Utils trim:str]];
}

+ (BOOL) validateAmount:(NSString *)str {

	NSString *balanceText = [Utils trim:str];

	BOOL validValue = YES;
	for (int i = 0; i < balanceText.length; i++) {
		NSString *c = [balanceText substringWithRange:NSMakeRange(i, 1)];
		if (![digits containsString:c]) {
            // Negative amounts for duals
            if (i == 0 && [c isEqualToString:@"-"]) {
                continue;
            }
			validValue = NO;
			break;
		}
	}

	if (validValue) {
		validValue = !([balanceText hasPrefix:@","] || [balanceText hasSuffix:@","]);
	}

	if (validValue) {
		NSArray *splits = [balanceText componentsSeparatedByString:@","];

		if (splits.count > 2) {
			validValue = NO;
		}
		else if (splits.count == 2) {
			NSString *fraction = splits[1];

			if (fraction.length > 2) {
				validValue = NO;
			}
		}
	}

	return validValue;
}

+ (NSString *) trim:(NSString *)text {
	return [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (BOOL) isEmpty:(UITextField *)tf {
	return [[Utils trim:tf.text] isEqualToString:@""];
}

+ (void) showMessage:(NSString *)message target:(id)delegate {
#ifdef MAINAPP
    [[[UIAlertView alloc] initWithTitle:nil
								message:message
							   delegate:delegate
					  cancelButtonTitle:@"Tamam"
					  otherButtonTitles:nil, nil]
	 show];
#else
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Tamam" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [delegate presentViewController:alert animated:YES completion:nil];
#endif
}

@end
