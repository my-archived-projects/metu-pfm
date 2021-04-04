//
//  PopoverTableVC.m
//  PFM
//
//  Created by Metehan Karabiber on 3/22/15.
//  Copyright (c) 2015 SM504 Project Team. All rights reserved.
//

#import "PopoverTableVC.h"
#import "TransactionVC.h"
#import "Account.h"

@interface PopoverTableVC ()

@end

@implementation PopoverTableVC

- (id) initWithArray:(NSArray *)array delegate:(id<PopoverTableDelegate>) delegate width:(CGFloat)w {
	self = [super init];
	self.delegate = delegate;
	self.array = array;
	self.preferredContentSize = CGSizeMake(w, array.count * 44);
	return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *identifier = @"PopoverCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
	
	id object = self.array[indexPath.row];
	
	if ([object isKindOfClass:[NSDate class]]) {
		cell.textLabel.text = [Utils getStringFrom:(NSDate *)object];
	}
	else if ([object isKindOfClass:[NSString class]]) {
		cell.textLabel.text = object;
	}
	else if ([object isKindOfClass:[NSManagedObject class]]) {
		cell.textLabel.text = ((Account *)object).name;
	}

	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate popoverSelected:self.array[indexPath.row] source:self.popoverSource];
}

@end
